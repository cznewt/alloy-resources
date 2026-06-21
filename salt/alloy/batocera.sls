# Grafana Alloy on Batocera — read-only root, so everything lives under the
# writable /userdata; run via a Batocera custom service (start/stop script).
{%- from "alloy/map.jinja" import alloy, release with context %}
{%- set base = '/userdata/system/alloy' %}

alloy-dir:
  file.directory:
    - name: {{ base }}
    - makedirs: True

# alloy-linux-amd64.zip -> {{ base }}/alloy-linux-amd64 ; symlink to ./alloy
alloy-binary:
  archive.extracted:
    - name: {{ base }}
    - source: {{ release }}/alloy-linux-amd64.zip
    - skip_verify: True
    - enforce_toplevel: False
    - require:
      - file: alloy-dir

alloy-binary-perms:
  file.managed:
    - name: {{ base }}/alloy-linux-amd64
    - mode: '0755'
    - replace: False
    - require:
      - archive: alloy-binary

# scenario pipelines (metrics + logs)
{%- for kind in ['metrics', 'logs'] %}
alloy-config-{{ kind }}:
  file.managed:
    - name: {{ base }}/{{ alloy.scenario }}-{{ kind }}.alloy
    - source: {{ alloy.repo_url }}/scenarios/{{ alloy.scenario }}/{{ alloy.scenario }}-{{ kind }}.alloy
    - skip_verify: True
    - require:
      - file: alloy-dir
{%- endfor %}

# Batocera custom service: /userdata/system/services/<name>, called `<name> start|stop`
alloy-service-script:
  file.managed:
    - name: /userdata/system/services/alloy
    - mode: '0755'
    - makedirs: True
    - contents: |
        #!/bin/bash
        # Batocera custom service: Grafana Alloy
        DIR={{ base }}
        PIDFILE=/var/run/alloy.pid
        export ALLOY_DATA_PATH=$DIR/data
        {%- for k, v in alloy.env.items() %}
        export {{ k }}="{{ v }}"
        {%- endfor %}
        case "$1" in
          start)
            mkdir -p "$ALLOY_DATA_PATH"
            "$DIR/alloy-linux-amd64" run --storage.path="$ALLOY_DATA_PATH" "$DIR" >/var/log/alloy.log 2>&1 &
            echo $! > "$PIDFILE" ;;
          stop)
            [ -f "$PIDFILE" ] && kill "$(cat $PIDFILE)" 2>/dev/null; rm -f "$PIDFILE" ;;
          restart) "$0" stop; sleep 1; "$0" start ;;
        esac

# enable + start the batocera service
alloy-service-enable:
  cmd.run:
    - name: batocera-services enable alloy && batocera-services start alloy
    - onchanges:
      - file: alloy-service-script
      {%- for kind in ['metrics', 'logs'] %}
      - file: alloy-config-{{ kind }}
      {%- endfor %}
