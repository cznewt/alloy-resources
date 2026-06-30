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

### [Linux](../scenarios/linux)

Configuration for monitoring a generic Linux host. Unlike the other scenarios,
the component modules are fetched over HTTP (`import.http`) straight from this
repository, so a host only needs the scenario file plus network access — no
mounted `modules/` volume required.

- **Metrics**: Collects system (node_exporter) and process metrics.
- **Logs**: Collects systemd journal logs.

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

### [Relay](../scenarios/relay)

A simple relay configuration for forwarding telemetry.

- **Metrics**: Forwards incoming metrics.
- **Logs**: Forwards incoming logs.
