# Instant Helm Chart

A Helm chart enables rapid deployment.

## Features

- Supports Deployment, StatefulSet, DaemonSet, and CronJob
- Config management via ConfigMap and Secret
- Includes Service and Ingress resources
- ArgoCD, FluxCD compatible

## Prerequisites

1. Kubernetes 1.16+
2. Helm (preferably v3) installed – instructions are [here](https://helm.sh/docs/intro/install/).
3. PheLab Helm repo configured

```bash
helm repo add phelab https://charts.phelab.com
helm repo update
```

## Get Started

Get the default values:

```bash
helm show values phelab/instant-chart
```

The output:

```yaml
## Number of pod replicas
##
replicas: 1

## A list of containers belonging to the pod
## E.g.
## containers:
##   - name: "my-container"
##     image: "my-image:latest"
##     ports:
##       - containerPort: 80
##     volumeMounts:
##       - name: "my-volume"
##         mountPath: "/data"
##         subPath: "my-subpath"
##         readOnly: true
containers: []

## Additional initialization containers
##
initContainers: []

## ....
```

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

| Name                         | Description                                        | Default |
| ---------------------------- | -------------------------------------------------- | ------- |
| `global.appVersion`          | Set app version label `app.kubernetes.io/version`. | `""`    |
| `global.labels`              | Add additional labels to the resources.            | `{}`    |
| `global.annotations`         | Add additional annotations to the resources.       | `{}`    |
| `global.defaultStorageClass` | Default storage class name for PVC.                | `""`    |

## Name override

| Name               | Description                          | Default |
| ------------------ | ------------------------------------ | ------- |
| `nameOverride`     | Override the default chart name.     | `""`    |
| `fullnameOverride` | Override the full name of resources. | `""`    |

### Deployment parameters

| Name               | Description                                                                                                      | Default |
| ------------------ | ---------------------------------------------------------------------------------------------------------------- | ------- |
| `replicas`         | Number of pod replicas.                                                                                          | `1`     |
| `containers`       | A list of containers belonging to the pod.                                                                       | `[]`    |
| `initContainers`   | Additional initialization containers.                                                                            | `[]`    |
| `volumes`          | A list of volumes to be added to the pod. PVC will be created if `volumes.persistentVolumeClaim.requests` found. | `[]`    |
| `imagePullSecrets` | Reference to one or more secrets to be used when pulling images.                                                 | `[]`    |
| `registryLogin`    | Create a Secret to provide the registry credentials for pulling private images.                                  | `[]`    |
| `securityContext`  | Define privilege and access control settings for a Pod or Container.                                             | `{}`    |
| `dnsConfig`        | DNS configuration for the pod.                                                                                   | `{}`    |
| `hostAliases`      | Host aliases for the pod.                                                                                        | `[]`    |
| `overhead`         | Overhead for the pod.                                                                                            | `{}`    |
| `readinessGates`   | Readiness gates for the pod.                                                                                     | `[]`    |

### Configuration parameters

| Name         | Description                                                  | Default |
| ------------ | ------------------------------------------------------------ | ------- |
| `configMaps` | List of ConfigMaps to create for storing non-sensitive data. | `{}`    |
| `secrets`    | List of Secrets to create for storing sensitive data.        | `{}`    |

### Service parameters

| Name                   | Description                                                                | Default     |
| ---------------------- | -------------------------------------------------------------------------- | ----------- |
| `service.enabled`      | Specifies whether a service should be created.                             | `true`      |
| `service.type`         | The type of the service (ClusterIP, NodePort, LoadBalancer, ExternalName). | `ClusterIP` |
| `service.ports`        | The ports that the service should expose.                                  | `[]`        |
| `service.annotations`  | Annotations to add to the service.                                         | `{}`        |
| `service.externalName` | Set external name when using ExternalName Service                          | `{}`        |

- If `service.ports` is empty or `service.ports.port` is not specified, the first container port of the first container (default `80`) will be used for both Service `port` and `targetPort`.
- If `service.ports.targetPort` is not specified, `service.ports.port` will be used for `targetPort`.

### Ingress parameters

| Name                  | Description                                                | Default |
| --------------------- | ---------------------------------------------------------- | ------- |
| `ingress.enabled`     | Specifies whether an ingress should be created.            | `false` |
| `ingress.className`   | Ingress class name.                                        | `""`    |
| `ingress.annotations` | Optionally specify additional annotations for the ingress. | `{}`    |
| `ingress.rules`       | The list of rules for the ingress.                         | `[]`    |
| `ingress.tls`         | Ingress TLS configuration.                                 | `[]`    |

### Pod Scheduling parameters

| Name                        | Description                                                                                                   | Default |
| --------------------------- | ------------------------------------------------------------------------------------------------------------- | ------- |
| `affinity`                  | Assign custom affinity rules to the pod.                                                                      | `{}`    |
| `nodeSelector`              | Define which Nodes the Pods are scheduled on.                                                                 | `{}`    |
| `nodeName`                  | Assign Pods to a specific node name.                                                                          | `""`    |
| `tolerations`               | Tolerations for use with node taints.                                                                         | `[]`    |
| `topologySpreadConstraints` | List of topology spread constraints to control how Pods are spread across your cluster among failure-domains. | `[]`    |

### Service Account parameters

| Name                         | Description                                                                           | Default     |
| ---------------------------- | ------------------------------------------------------------------------------------- | ----------- |
| `serviceAccount.create`      | Specifies whether a service account should be created.                                | `true`      |
| `serviceAccount.name`        | The name of the service account to use.                                               | `"default"` |
| `serviceAccount.automount`   | Specifies whether to automatically mount the API credentials for the service account. | `true`      |
| `serviceAccount.annotations` | Annotations to add to the service account.                                            | `{}`        |

### Container Healthcheck parameters

The `livenessProbe`, `readinessProbe` and `startupProbe` can be enabled by adding the corresponding fields. The default probe will use `tcpSocket` with the first container port detected (default `80`).

For example:

```yaml
# values.yaml
containers:
- image: my-app:latest
  ports:
  - containerPort: 3000
  livenessProbe:
    enabled: true

# output:
containers:
- name: container-0
  image: my-app:latest
  ports:
  - containerPort: 3000
  livenessProbe:
    tcpSocket:
      port: 3000
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 5
    failureThreshold: 5
    successThreshold: 1
```

### Resource kind

| Name   | Description                                         | Default      |
| ------ | --------------------------------------------------- | ------------ |
| `kind` | `Deployment`, `StatefulSet`, `DaemonSet`, `CronJob` | `Deployment` |

### StatefulSet parameters

| Name                                   | Description                                                                                         | Default |
| -------------------------------------- | --------------------------------------------------------------------------------------------------- | ------- |
| `ordinals`                             | Configuration for managing StatefulSet pod ordinals.                                                | `{}`    |
| `serviceName`                          | The name of the service that governs this StatefulSet. If not provided, it is generated by default. | `""`    |
| `podManagementPolicy`                  | Controls how pods are created during initial scale up, replacement, or scaling down.                | `""`    |
| `persistentVolumeClaimRetentionPolicy` | Configuration for retention policy of persistent volume claims.                                     |         |
| `volumeClaimTemplates`                 | Configuration templates for defining volume claims in the StatefulSet.                              |         |

### CronJob

| Name                      | Description                                                                                                          | Default     |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------- | ----------- |
| `schedule`                | The schedule in Cron format. [More info](https://en.wikipedia.org/wiki/Cron)                                         | `* * * * *` |
| `timeZone`                | The time zone name for the given schedule. [More info](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | `""`        |
| `concurrencyPolicy`       | Specifies how to treat concurrent executions of a Job.                                                               | `Allow`     |
| `backoffLimit`            | Number of retries before marking a Job as failed.                                                                    |             |
| `backoffLimitPerIndex`    | Number of retries per index before marking a Job as failed.                                                          |             |
| `parallelism`             | Number of concurrent Jobs allowed to run.                                                                            |             |
| `completions`             | Number of successfully completed pods required to mark the Job as complete.                                          |             |
| `activeDeadlineSeconds`   | Duration in seconds for which the Job can remain active before terminating.                                          |             |
| `completionMode`          | Mode for tracking Job completions.                                                                                   |             |
| `manualSelector`          | Specifies if the selector for Jobs should be manually defined.                                                       |             |
| `maxFailedIndexes`        | Maximum failed indexes before marking Job as failed.                                                                 |             |
| `podFailurePolicy`        | Configuration for handling pod failures.                                                                             |             |
| `podReplacementPolicy`    | Policy for replacing failed or terminating pods.                                                                     |             |
| `ttlSecondsAfterFinished` | Time to retain Job resources after completion.                                                                       |             |
