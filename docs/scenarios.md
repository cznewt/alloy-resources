# Alloy Scenarios

Scenarios are pre-configured Alloy setups that combine multiple modules to monitor specific environments or devices.

## Available Scenarios

### [Batocera](../scenarios/batocera)

Configuration for monitoring Batocera retro-gaming systems.

- **Metrics**: Collects system and emulation metrics.
- **Logs**: Collects system logs.

### [Docker Host](../scenarios/docker)

Configuration for monitoring a host running Docker.

- **Metrics**: Collects Docker engine and container metrics.
- **Logs**: Collects container logs.

### [HassOS (Home Assistant)](../scenarios/hassos)

Configuration for monitoring Home Assistant OS.

- **Metrics**: Collects system metrics.
- **Logs**: Collects system and application logs.

### [Kubernetes](../scenarios/kubernetes)

Control-plane certificate expiry for a Kubernetes cluster, through the
`networking/blackbox` module (pulled over HTTP, like Linux). Runs inside the
cluster under a service account that may list endpointslices and nodes - e.g.
the k8s-monitoring `alloy-metrics` instance, whose `extraConfig` can take the
blocks above the sink as they are.

- **Metrics**: `probe_success` and `probe_ssl_earliest_cert_expiry` for every
  kube-apiserver behind `default/kubernetes` (TLS verified against the
  service-account CA as `kubernetes`, so a wrong or expired certificate fails
  the probe) and for every node's kubelet on `:10250` (self-signed: read, not
  verified). Series carry `job="integrations/blackbox"` and
  `instance="apiserver-<ip>"` / `"kubelet-<node>"`.
- `kubernetes-certs-metrics.alloy` — self-hosted Mimir (`METRICS_PRIMARY_URL`,
  `TENANT`, `CLUSTER_NAME`, `ENV`).

kubeadm serving certificates last one year and nothing renews them on its own;
the observ-viz `monitoring.blackboxExporter` alerts fire 14 (warning) and 7
(critical) days before `probe_ssl_earliest_cert_expiry`.

### [Linux](../scenarios/linux)

Configuration for monitoring a generic Linux host. Unlike the other scenarios,
the component modules are fetched over HTTP (`import.http`) straight from this
repository, so a host only needs the scenario file plus network access — no
mounted `modules/` volume required.

- **Metrics**: Collects system (node_exporter) and process metrics.
- **Logs**: Collects systemd journal logs.

Same Cloud / self-hosted split as Windows:

- `linux-metrics.alloy` / `linux-logs.alloy` — **Grafana Cloud** (basic auth).
- `linux-metrics-selfhosted.alloy` / `linux-logs-selfhosted.alloy` — **self-hosted**
  Mimir/Loki; tenant via `X-Scope-OrgID` / `tenant_id` from the `TENANT` env (default
  `gedu`). The variant gedu's Linux nodes use (vendored by alcali's `alloy._debian`).

### [Proxmox](../scenarios/proxmox)

Configuration for monitoring a Proxmox VE node. Alloy runs natively on the
hypervisor; component modules are fetched over HTTP.

- **Metrics**: host OS (node_exporter, systemd collector enabled) plus Proxmox
  VE API metrics via an external proxmox-exporter.
- **Logs**: systemd journal logs (PVE / qemu / kernel services).

### [Windows](../scenarios/windows)

Configuration for monitoring a Windows host. Alloy runs natively as a Windows
service and scrapes the built-in `windows_exporter` (no external exporter).

- **Metrics**: host metrics via windows_exporter, including the textfile
  collector (`*.prom` from `TEXTFILE_DIRECTORY`, default `C:\apps\alloy\textfile`).
- **Logs**: Windows Event Log (Application + System channels).

Two delivery variants share the same collectors:

- `windows-metrics.alloy` / `windows-logs.alloy` — **Grafana Cloud** (basic auth via
  `METRICS_PRIMARY_USER` / `METRICS_PRIMARY_PASSWORD`).
- `windows-metrics-selfhosted.alloy` / `windows-logs-selfhosted.alloy` — **self-hosted**
  Mimir/Loki; tenant via the `X-Scope-OrgID` header from the `TENANT` env (default
  `gedu`), no basic auth. This is the variant gedu's Windows nodes use — alcali's
  `alloy._windows` state vendors it, parameterised from the os-bakery `pillar.alloy`
  metrics/logs destinations (mirrors the Linux self-hosted split).

### [Relay](../scenarios/relay)

A simple relay configuration for forwarding telemetry.

- **Metrics**: Forwards incoming metrics.
- **Logs**: Forwards incoming logs.
