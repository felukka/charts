# koptan

Kubernetes application chart for deploying the `koptan` controller.

## Chart Information

- Name: `koptan`
- Type: `application`
- Chart version: `0.1.0`
- App version: `0.1.0`

## Prerequisites

- Kubernetes cluster
- Helm v3+

## Add Repository

```bash
helm repo add felukka https://charts.felukka.org
helm repo update
```

## Install

From repository:

```bash
helm install koptan felukka/koptan
```

From local source:

```bash
helm install koptan charts/koptan
```

## Upgrade

From repository:

```bash
helm upgrade koptan felukka/koptan
```

From local source:

```bash
helm upgrade koptan charts/koptan
```

## Uninstall

```bash
helm uninstall koptan
```

