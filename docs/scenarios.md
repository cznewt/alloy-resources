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

### [Relay](../scenarios/relay)

A simple relay configuration for forwarding telemetry.

- **Metrics**: Forwards incoming metrics.
- **Logs**: Forwards incoming logs.
