# Koptan UI

A Helm chart for the Koptan UI: the Backstage app with Bay, Raseef pipelines, Self Service, Scan Bay and Signal Mast. It talks to the Kubernetes API with its own service account and needs the [Koptan operator](../koptan/README.md) installed.

> **Warning: no authentication yet.** The UI uses Backstage guest sign-in and an allow-all permission policy. Anyone who can reach it can deploy services and prompt SelfService agents. The chart therefore ships with the Ingress **disabled**. Reach the UI with `kubectl port-forward`, or put an Ingress behind your own authentication (an OAuth2 proxy, VPN, or similar).

## Installation

Install the UI into the operator namespace, so it can read the operator's `koptan-agent-key` Secret:

```bash
helm install koptan-ui oci://ghcr.io/felukka/charts/koptan-ui -n koptan-system

kubectl -n koptan-system port-forward svc/koptan-ui 7007:7007
# open http://localhost:7007
```

From the HTTPS repository: `helm install koptan-ui felukka/koptan-ui -n koptan-system`.

## Configuration

| Value | Default | Description |
|---|---|---|
| `baseUrl` | `http://localhost:7007` | URL browsers use to reach the UI. Set it to the Ingress URL when you enable one. |
| `koptan.namespace` | `""` | Limit the UI to one namespace; empty means all namespaces. |
| `agentKey.secret` | `koptan-agent-key` / `key` | Secret with the operator's `KOPTAN_AGENT_KEY`. Without it the Self Service page cannot reach agents. |
| `database.postgres.enabled` | `false` | Without Postgres the UI uses in-memory SQLite. Koptan data lives in the cluster, so only UI state (settings, notifications) is lost on restart. |
| `auth.allowGuest` | `true` | Backstage refuses guest sign-in in a production build unless allowed. Without it nobody can sign in. Set it to `false` once `appConfig` configures a real provider. |
| `ingress.enabled` | `false` | See the warning above. |
| `rbac.create` | `true` | ClusterRole and binding for the UI's service account (koptan `config/rbac/backstage_role.yaml`). |
| `appConfig` | `{}` | Extra Backstage configuration, loaded last (for example an auth provider). |

### Postgres

```yaml
database:
  postgres:
    enabled: true
    host: postgres.example.svc
    user: backstage
    existingSecret: koptan-ui-postgres   # key "password"
```

### Ingress

```yaml
baseUrl: https://koptan.example.com
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: koptan.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: koptan-ui-tls
      hosts: [koptan.example.com]
```

## Uninstalling the Chart

```bash
helm uninstall koptan-ui -n koptan-system
```
