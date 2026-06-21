# Grafana Alloy on Ubuntu/Debian — apt repo + package + scenario config + service.
{%- from "alloy/map.jinja" import alloy, release with context %}

alloy-keyring-dir:
  file.directory:
    - name: /etc/apt/keyrings
    - makedirs: True

alloy-gpg-key:
  cmd.run:
    - name: wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null
    - creates: /etc/apt/keyrings/grafana.gpg
    - require:
      - file: alloy-keyring-dir

alloy-apt-repo:
  pkgrepo.managed:
    - name: deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main
    - file: /etc/apt/sources.list.d/grafana.list
    - require:
      - cmd: alloy-gpg-key

alloy-package:
  pkg.installed:
    - name: alloy
    - refresh: True
    - require:
      - pkgrepo: alloy-apt-repo

# scenario pipelines (metrics + logs) — alloy loads every *.alloy in the dir
{%- for kind in ['metrics', 'logs'] %}
alloy-config-{{ kind }}:
  file.managed:
    - name: /etc/alloy/{{ alloy.scenario }}-{{ kind }}.alloy
    - source: {{ alloy.repo_url }}/scenarios/{{ alloy.scenario }}/{{ alloy.scenario }}-{{ kind }}.alloy
    - skip_verify: True
    - makedirs: True
    - require:
      - pkg: alloy-package
    - watch_in:
      - service: alloy-service
{%- endfor %}

# point alloy at the config dir + inject the sink credentials/labels (sys.env)
alloy-defaults:
  file.managed:
    - name: /etc/default/alloy
    - contents: |
        CONFIG_FILE="/etc/alloy"
        CUSTOM_ARGS=""
        RESTART_ON_UPGRADE=true
        {%- for k, v in alloy.env.items() %}
        {{ k }}="{{ v }}"
        {%- endfor %}
    - require:
      - pkg: alloy-package
    - watch_in:
      - service: alloy-service

alloy-service:
  service.running:
    - name: alloy
    - enable: True
    - require:
      - pkg: alloy-package
