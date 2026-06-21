# Salt formula — install Grafana Alloy

Installs Grafana Alloy and deploys an [alloy-resources scenario](../scenarios)
(its `*-metrics.alloy` + `*-logs.alloy`) on a host, per OS.

## Supported platforms

| OS | Install | Service | Config dir |
|----|---------|---------|------------|
| **Ubuntu / Debian** (`alloy.ubuntu`) | `apt` (grafana repo) | systemd `alloy` | `/etc/alloy` (`CONFIG_FILE=/etc/alloy`) |
| **Windows** (`alloy.windows`) | release binary (zip) | `sc` service `Alloy` | `C:\Program Files\GrafanaLabs\Alloy\config` |
| **Batocera** (`alloy.batocera`) | release binary → `/userdata` | Batocera custom service | `/userdata/system/alloy` |

`init.sls` auto-dispatches on grains (`os_family` / `kernel` / `os`).

## Use

```sh
salt '<host>' state.apply alloy
```

Configure via pillar (copy `alloy/pillar.example.sls`):

```yaml
alloy:
  version: "1.10.2"
  scenario: proxmox          # linux | proxmox | windows | batocera
  env:                       # injected into the service env -> sys.env()
    METRICS_PRIMARY_URL: ...
    LOGS_PRIMARY_URL: ...
    # ...
```

The scenario files are fetched over HTTP from this repo (`repo_url`), so hosts
need outbound access to `raw.githubusercontent.com` (or set `repo_url` to a
mirror). Secrets live only in pillar, never in the alloy config.

> Notes: remote downloads use `skip_verify` for simplicity — pin `source_hash`
> for production. The Windows service env is set via the service's registry
> `Environment` value; Batocera runs alloy from a custom service script under
> `/userdata/system/services/`.
