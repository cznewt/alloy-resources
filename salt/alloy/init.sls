# Install Grafana Alloy + deploy a scenario config, dispatched per OS.
#   salt '<host>' state.apply alloy
# Configure via pillar (see pillar.example.sls).
{%- if grains['kernel'] == 'Windows' %}
include:
  - alloy.windows
{%- elif grains['os']|lower == 'batocera' %}
include:
  - alloy.batocera
{%- elif grains['os_family'] == 'Debian' %}
include:
  - alloy.ubuntu
{%- else %}
alloy-unsupported-os:
  test.fail_without_changes:
    - name: "alloy formula supports Debian/Ubuntu, Windows, Batocera — got '{{ grains['os'] }}'"
{%- endif %}
