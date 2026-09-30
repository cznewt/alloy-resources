# OpenBao Module

Handles scraping the telemetry of [OpenBao](https://openbao.org) - and of
HashiCorp Vault, which serves the same endpoint with the same `vault_*` metric
names.

The metrics live at `/v1/sys/metrics` and come in Prometheus format only with
`?format=prometheus`, which annotation-based autodiscovery (e.g. the
k8s-monitoring chart's) cannot pass. The server has to allow the scrape:

```hcl
listener "tcp" {
  # ...
  telemetry {
    unauthenticated_metrics_access = true
  }
}
telemetry {
  prometheus_retention_time = "24h"
  disable_hostname          = true
}
```

A sealed server exports only `vault_core_unsealed`, the barrier and the Go
runtime; request, token and lease metrics appear once it is unsealed. The
observ-viz `cicd.vault` board and its `VaultSealed` alert read these series.

## Components

-   [`kubernetes`](#kubernetes)
-   [`local`](#local)
-   [`scrape`](#scrape)

### `kubernetes`

Discovers OpenBao pods and exports them as targets; it does not scrape.

#### Arguments

| Name              | Required | Default                              | Description                                                                                                                               |
| :---------------- | :------- | :----------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------- |
| `namespaces`      | _no_     | `[]`                                 | The namespaces to look for targets in, the default (`[]`) is all namespaces                                                               |
| `field_selectors` | _no_     | `[]`                                 | The [field selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/field-selectors/) to use to find matching targets |
| `label_selectors` | _no_     | `["app.kubernetes.io/name=openbao"]` | The [label selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) to use to find matching targets          |
| `port_name`       | _no_     | `http`                               | The name of the API port to scrape                                                                                                        |

Pods are kept when they are `Running` - not only when ready: the chart's
readiness probe fails while the server is sealed, which is exactly when it
must stay monitored.

#### Labels

| Label       | Description                            |
| :---------- | :------------------------------------- |
| `namespace` | The namespace the target was found in  |
| `pod`       | The full name of the pod               |
| `instance`  | The pod name                           |
| `container` | The name of the container              |
| `source`    | `kubernetes`                           |

### `local`

A static target on this host.

| Name   | Required | Default | Description      |
| :----- | :------- | :------ | :--------------- |
| `port` | _no_     | `8200`  | The API port     |

### `scrape`

#### Arguments

| Name              | Required | Default                | Description                                                                                                                                                              |
| :---------------- | :------- | :--------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `targets`         | _yes_    | `list(map(string))`    | List of targets to scrape                                                                                                                                                |
| `forward_to`      | _yes_    | `list(MetricsReceiver)`| Where the collected metrics are forwarded to                                                                                                                             |
| `job_label`       | _no_     | `integrations/openbao` | The job label for all metrics                                                                                                                                            |
| `cluster`         | _no_     | none                   | Cluster label set on the targets. `vault_core_unsealed` carries the server's own cluster name once unsealed, which would win over a remote_write external label; set here, the platform's name wins and the server's lands in `exported_cluster` |
| `scheme`          | _no_     | `http`                 | `http` or `https`                                                                                                                                                        |
| `keep_metrics`    | _no_     | `(.+)`                 | A regex of metrics to keep                                                                                                                                               |
| `drop_metrics`    | _no_     | `(^go_.+$)`            | A regex of metrics to drop (`process_*` stays: `process_start_time_seconds` is the uptime)                                                                               |
| `scrape_interval` | _no_     | `60s`                  | How often to scrape                                                                                                                                                      |
| `scrape_timeout`  | _no_     | `10s`                  | How long before a scrape times out                                                                                                                                       |
| `max_cache_size`  | _no_     | `100000`               | The maximum number of elements to hold in the relabeling cache                                                                                                           |
| `clustering`      | _no_     | `false`                | Whether or not [clustering](https://grafana.com/docs/alloy/latest/get-started/clustering/) should be enabled                                                             |

## Usage

### Kubernetes (e.g. in k8s-monitoring `alloy-metrics.extraConfig`)

```alloy
import.http "openbao" {
  url = "https://raw.githubusercontent.com/cznewt/alloy-resources/main/modules/security/openbao/metrics.alloy"
}

openbao.kubernetes "targets" {
  namespaces = ["gedu-openbao"]
}

openbao.scrape "metrics" {
  targets    = openbao.kubernetes.targets.output
  cluster    = "gedu-prg"
  forward_to = [prometheus.remote_write.primary_prometheus.receiver]
}
```

### Local

```alloy
openbao.local "targets" {}

openbao.scrape "metrics" {
  targets    = openbao.local.targets.output
  forward_to = [prometheus.remote_write.default.receiver]
}
```
