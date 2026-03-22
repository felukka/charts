# Felukka Helm Charts

Welcome to the Felukka Helm Charts repository.

## Usage

You can use these charts via the standard HTTPS Helm repository or directly from our OCI registry (GitHub Container Registry).

### Install

Add the Helm repository to your local system:

```bash
helm repo add felukka https://charts.felukka.org
helm repo update
```

Search for available charts:

```bash
helm search repo felukka
```

## Available Charts

* [**Koptan**](./charts/koptan/README.md) - Description of the Koptan chart.
