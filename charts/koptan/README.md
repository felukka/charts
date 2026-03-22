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

## Uninstalling the Chart

To uninstall/delete the `koptan` deployment:

```bash
helm uninstall koptan -n koptan-system
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
