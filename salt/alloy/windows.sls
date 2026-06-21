# Grafana Alloy on Windows — binary + service + scenario config.
# Note: env for sys.env() is injected via the service's registry Environment value.
{%- from "alloy/map.jinja" import alloy, release with context %}
{%- set base = 'C:\\Program Files\\GrafanaLabs\\Alloy' %}

alloy-dir:
  file.directory:
    - name: '{{ base }}'
    - makedirs: True

alloy-config-dir:
  file.directory:
    - name: '{{ base }}\\config'
    - makedirs: True

# alloy-windows-amd64.exe.zip -> alloy-windows-amd64.exe
alloy-binary:
  archive.extracted:
    - name: '{{ base }}'
    - source: {{ release }}/alloy-windows-amd64.exe.zip
    - skip_verify: True
    - enforce_toplevel: False
    - require:
      - file: alloy-dir

# scenario pipelines (metrics + logs)
{%- for kind in ['metrics', 'logs'] %}
alloy-config-{{ kind }}:
  file.managed:
    - name: '{{ base }}\\config\\{{ alloy.scenario }}-{{ kind }}.alloy'
    - source: {{ alloy.repo_url }}/scenarios/{{ alloy.scenario }}/{{ alloy.scenario }}-{{ kind }}.alloy
    - skip_verify: True
    - require:
      - file: alloy-config-dir
{%- endfor %}

# create the service (idempotent)
alloy-service-create:
  cmd.run:
    - name: 'sc.exe create Alloy binPath= "\"{{ base }}\\alloy-windows-amd64.exe\" run \"{{ base }}\\config\"" start= auto DisplayName= "Grafana Alloy"'
    - unless: 'sc.exe query Alloy'
    - require:
      - archive: alloy-binary

# sink credentials/labels for sys.env() — service-scoped environment (REG_MULTI_SZ)
alloy-service-env:
  reg.present:
    - name: 'HKLM\SYSTEM\CurrentControlSet\Services\Alloy'
    - vname: Environment
    - vtype: REG_MULTI_SZ
    - vdata:
      {%- for k, v in alloy.env.items() %}
      - '{{ k }}={{ v }}'
      {%- endfor %}
    - require:
      - cmd: alloy-service-create

alloy-service:
  service.running:
    - name: Alloy
    - enable: True
    - watch:
      - reg: alloy-service-env
      {%- for kind in ['metrics', 'logs'] %}
      - file: alloy-config-{{ kind }}
      {%- endfor %}
    - require:
      - cmd: alloy-service-create
