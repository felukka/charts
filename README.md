# Koptan Helm Chart Repository

Helm charts for Koptan - a Kubernetes controller for managing .NET, Go, and Java applications.

**Repository**: https://charts.felukka.org

## Available Charts

### koptan

A Helm chart for deploying the Koptan controller to manage custom resources for application deployment.

#### Features

- **Custom Resource Definitions (CRDs)** for:
  - DotnetApp
  - GoApp
  - JavaApp
  - Slipway
  - Voyage

- **RBAC Configuration**: Properly configured ClusterRole and ClusterRoleBinding for secure operation
- **Security**: Running with `runAsNonRoot`, `readOnlyRootFilesystem`, and `allowPrivilegeEscalation: false`
- **Health Checks**: Configured liveness and readiness probes
- **Resource Management**: Configurable CPU and memory limits/requests
- **Autoscaling**: Optional HorizontalPodAutoscaler support
- **Ingress Support**: Both traditional Ingress and Gateway API HTTPRoute support

#### Installation

```bash
helm repo add koptan https://charts.felukka.org
helm repo update
helm install koptan koptan/koptan
```

#### Configuration

Key values you can override:

```yaml
# Replica count
replicaCount: 1

# Controller image configuration
controller:
  image:
    repository: controller
    tag: latest
    pullPolicy: IfNotPresent

# Service configuration
service:
  type: ClusterIP
  port: 8080

# Resource limits and requests
resources:
  limits:
    cpu: 500m
    memory: 128Mi
  requests:
    cpu: 10m
    memory: 64Mi

# Enable autoscaling
autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 100
  targetCPUUtilizationPercentage: 80

# Ingress configuration
ingress:
  enabled: false

# Gateway API HTTPRoute configuration
httpRoute:
  enabled: false
```

#### Example Values Override

```bash
helm install koptan koptan/koptan \
  --set replicaCount=3 \
  --set autoscaling.enabled=true \
  --set autoscaling.maxReplicas=10
```

#### More Information

- [Koptan Project](https://github.com/felukka/koptan)
- [Kubernetes Documentation](https://kubernetes.io)
- [Helm Documentation](https://helm.sh)
