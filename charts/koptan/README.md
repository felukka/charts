# Koptan Operator

A Helm chart for deploying the Koptan Operator on Kubernetes.

## Prerequisites

- Kubernetes 1.20+
- Helm 3.8.0+ (for OCI support)

## Installation

You can install this chart using either the OCI registry (recommended) or the standard HTTPS Helm repository.

### Option 1: Install from OCI Registry (GHCR)

Helm 3.8+ supports OCI registries by default. You can install the chart directly from the GitHub Container Registry:

```bash
# Install the latest version
helm install koptan oci://ghcr.io/felukka/koptan -n koptan-system --create-namespace

# Install a specific version
helm install koptan oci://ghcr.io/felukka/koptan --version <chart-version> -n koptan-system --create-namespace
```

### Option 2: Install from HTTPS Repository

Alternatively, use the Felukka Helm repository:

```bash
# Add the repository
helm repo add felukka https://charts.felukka.org
helm repo update

# Install the chart
helm install koptan felukka/koptan -n koptan-system --create-namespace
```

## Configuration

You can configure the Koptan operator by providing a custom `values.yaml` file.

To see all available configuration options and their default values, extract the default `values.yaml` using the following command:

```bash
helm show values oci://ghcr.io/felukka/koptan > values.yaml
```

Once you have modified the `values.yaml` file with your desired settings, apply it during installation:

```bash
helm install koptan oci://ghcr.io/felukka/koptan -f values.yaml -n koptan-system
```

## Self-service agent key

SelfServices need a key that derives each agent's API token. The Backstage backend uses the same value. Without the key the operator runs normally, but SelfServices stay disabled.

```bash
kubectl -n koptan-system create secret generic koptan-agent-key \
  --from-literal=key=$(openssl rand -hex 32)
```

The Secret name and key are set by `agent.keySecret`. The agent image is set by `agent.image`.

## Backstage RBAC

To let the Backstage backend plugin manage Koptan resources, create its ClusterRole and bind it to the service account Backstage uses:

```bash
helm upgrade --install koptan oci://ghcr.io/felukka/koptan -n koptan-system \
  --set backstage.rbac.create=true \
  --set backstage.rbac.serviceAccount.name=backstage \
  --set backstage.rbac.serviceAccount.namespace=backstage
```

## Upgrading from 0.1.x

Version 0.2.0 replaces the `koptan.felukka.sh/v1alpha` API (GoApp, JavaApp, DotnetApp, Slipway, Voyage) with `koptan.felukka.org/v1` (Service, CI, CD, CIPlugin, Alert, SelfService). Old resources are not migrated, and the admission webhooks are gone.

Helm installs the CRDs in `crds/` only on first install. It never upgrades or deletes them. To upgrade, apply the new CRDs yourself and remove the old ones:

```bash
helm pull oci://ghcr.io/felukka/koptan --version 0.2.0 --untar
kubectl apply --server-side -f koptan/crds/
helm upgrade koptan oci://ghcr.io/felukka/koptan --version 0.2.0 -n koptan-system

# After you have exported anything you need from the old resources:
kubectl delete crd goapps.koptan.felukka.sh javaapps.koptan.felukka.sh \
  dotnetapps.koptan.felukka.sh slipways.koptan.felukka.sh voyages.koptan.felukka.sh
```

## Uninstalling the Chart

To uninstall/delete the `koptan` deployment:

```bash
helm uninstall koptan -n koptan-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
