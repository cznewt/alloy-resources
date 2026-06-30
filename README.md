# Alloy Resources

- **[Modules](docs/modules.md)**: Detailed list of available Alloy component modules.
- **[Scenarios](docs/scenarios.md)**: Pre-configured scenarios for specific environments.

## Overview

### Primary Scenarios

| Scenario | Description | Key Modules |
| :--- | :--- | :--- |
| **[Batocera](scenarios/batocera)** | Retro-gaming console monitoring. | `system/batocera`, `system/linux` |
| **[Docker](scenarios/docker)** | Docker host monitoring. | `system/docker`, `system/linux` |
| **[HassOS](scenarios/hassos)** | Home Assistant OS monitoring. | `system/linux`, `utils/logs` |
| **[Linux](scenarios/linux)** | Generic Linux host monitoring; modules loaded over HTTP. | `system/linux`, `utils/logs` |
| **[Proxmox](scenarios/proxmox)** | Proxmox VE node monitoring (host OS + PVE API + journal). | `system/linux`, `system/proxmox`, `utils/logs` |
| **[Windows](scenarios/windows)** | Windows host monitoring (windows_exporter metrics + Event Log). | — (inline `windows_exporter`) |
| **[Relay](scenarios/relay)** | Telemetry forwarder. | `collector/alloy` |

### Module Categories

| Category | Description | Examples |
| :--- | :--- | :--- |
| **[System](docs/modules.md#system)** | OS and Container monitoring. | `linux`, `docker`, `batocera` |
| **[Kubernetes](docs/modules.md#kubernetes)** | Kubernetes cluster monitoring. | `core`, `kube-state-metrics`, `opencost` |
| **[Databases](docs/modules.md#databases)** | DB and KV store monitoring. | `postgres`, `mysql`, `redis`, `etcd` |
| **[Monitoring](docs/modules.md#monitoring)** | Observability backend monitoring. | `loki`, `mimir`, `tempo`, `pyroscope` |
| **[Cloud](docs/modules.md#cloud)** | Cloud provider integrations. | `aws`, `azure`, `gcp` |
| **[Networking](docs/modules.md#networking)** | Network monitoring tools. | `blackbox`, `haproxy` |
| **[Collector](docs/modules.md#collector)** | Telemetry collectors. | `agent`, `alloy`, `statsd` |


## Usage

### Test scenarios

```
just test-(batocera/dockar/hassos)-scenario
```
