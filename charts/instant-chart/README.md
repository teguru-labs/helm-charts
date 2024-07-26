# Instant Helm Chart

A Helm chart enables rapid deployment.

## Prerequisites

1. Kubernetes 1.16+
2. Helm (preferably v3) installed – instructions are [here](https://helm.sh/docs/intro/install/).
3. PheLab Helm repo configured

```bash
helm repo add phelab https://charts.phelab.com
helm repo update
```

## Get Started

### Install Helm Chart

```bash
helm upgrade --install [RELEASE_NAME] phelab/instant-chart
```

See [configuration](#parameters) below.

See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation.

### Uninstall Helm Chart

```bash
helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation.

## Parameters

## Global parameters

| Name                         | Description                                        | Value |
| ---------------------------- | -------------------------------------------------- | ----- |
| `global.appVersion`          | Set app version label `app.kubernetes.io/version`. | `{}`  |
| `global.labels`              | Add additional labels to the resources.            | `{}`  |
| `global.annotations`         | Add additional annotations to the resources.       | `{}`  |
| `global.defaultStorageClass` | Default storage class name for PVC.                | `{}`  |

## Name override

| Name               | Description                          | Value |
| ------------------ | ------------------------------------ | ----- |
| `nameOverride`     | Override the default chart name.     | `""`  |
| `fullnameOverride` | Override the full name of resources. | `""`  |

### Deployment parameters

| Name               | Description                                                                                                      | Value |
| ------------------ | ---------------------------------------------------------------------------------------------------------------- | ----- |
| `replicas`         | Number of pod replicas.                                                                                          | `1`   |
| `containers`       | A list of containers belonging to the pod.                                                                       | `[]`  |
| `initContainers`   | Additional initialization containers.                                                                            | `[]`  |
| `volumes`          | A list of volumes to be added to the pod. PVC will be created if `volumes.persistentVolumeClaim.requests` found. | `[]`  |
| `imagePullSecrets` | Reference to one or more secrets to be used when pulling images.                                                 | `[]`  |
| `registryLogin`    | Create a Secret to provide the registry credentials for pulling private images.                                  | `[]`  |
| `securityContext`  | Define privilege and access control settings for a Pod or Container.                                             | `{}`  |
| `dnsConfig`        | DNS configuration for the pod.                                                                                   | `{}`  |
| `hostAliases`      | Host aliases for the pod.                                                                                        | `[]`  |
| `overhead`         | Overhead for the pod.                                                                                            | `{}`  |
| `readinessGates`   | Readiness gates for the pod.                                                                                     | `[]`  |

### Configuration parameters

| Name         | Description                                                  | Value |
| ------------ | ------------------------------------------------------------ | ----- |
| `configMaps` | List of ConfigMaps to create for storing non-sensitive data. | `{}`  |
| `secrets`    | List of Secrets to create for storing sensitive data.        | `{}`  |

### Service parameters

| Name                   | Description                                                                | Value       |
| ---------------------- | -------------------------------------------------------------------------- | ----------- |
| `service.enabled`      | Specifies whether a service should be created.                             | `true`      |
| `service.type`         | The type of the service (ClusterIP, NodePort, LoadBalancer, ExternalName). | `ClusterIP` |
| `service.ports`        | The ports that the service should expose.                                  |             |
| `service.annotations`  | Annotations to add to the service.                                         | `{}`        |
| `service.externalName` | Set external name when using ExternalName Service                          | `{}`        |

### Ingress parameters

| Name                  | Description                                                | Value   |
| --------------------- | ---------------------------------------------------------- | ------- |
| `ingress.enabled`     | Specifies whether an ingress should be created.            | `false` |
| `ingress.className`   | Ingress class name.                                        | `""`    |
| `ingress.annotations` | Optionally specify additional annotations for the ingress. | `{}`    |
| `ingress.rules`       | The list of rules for the ingress.                         | `[]`    |
| `ingress.tls`         | Ingress TLS configuration.                                 | `[]`    |

### Pod Scheduling parameters

| Name                        | Description                                                                                                   | Value |
| --------------------------- | ------------------------------------------------------------------------------------------------------------- | ----- |
| `affinity`                  | Assign custom affinity rules to the pod.                                                                      | `{}`  |
| `nodeSelector`              | Define which Nodes the Pods are scheduled on.                                                                 | `{}`  |
| `nodeName`                  | Assign Pods to a specific node name.                                                                          | `""`  |
| `tolerations`               | Tolerations for use with node taints.                                                                         | `[]`  |
| `topologySpreadConstraints` | List of topology spread constraints to control how Pods are spread across your cluster among failure-domains. | `[]`  |

### Service Account parameters

| Name                         | Description                                                                           | Value  |
| ---------------------------- | ------------------------------------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created.                                | `true` |
| `serviceAccount.name`        | The name of the service account to use.                                               | `""`   |
| `serviceAccount.automount`   | Specifies whether to automatically mount the API credentials for the service account. | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account.                                            | `{}`   |
