# Example pillar for the alloy formula. Assign per host/group and adjust.
alloy:
  version: "1.10.2"
  # which scenario to deploy (scenarios/<scenario>/<scenario>-{metrics,logs}.alloy)
  #   linux | proxmox | windows | batocera
  scenario: linux
  repo_url: https://raw.githubusercontent.com/cznewt/alloy-resources/main
  # written to the service environment, consumed by the scenarios via sys.env()
  env:
    METRICS_PRIMARY_URL: https://prometheus.example.com/api/v1/push
    METRICS_PRIMARY_USER: "12345"
    METRICS_PRIMARY_PASSWORD: "<token>"
    LOGS_PRIMARY_URL: https://loki.example.com/loki/api/v1/push
    LOGS_PRIMARY_USER: "67890"
    LOGS_PRIMARY_PASSWORD: "<token>"
    CLUSTER_NAME: my-cluster
    # proxmox scenario only:
    # PROXMOX_EXPORTER_ADDR: 127.0.0.1:8080
