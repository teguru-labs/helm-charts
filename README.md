# Teguru - Helm Charts

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/teguru)](https://artifacthub.io/packages/search?repo=teguru)
[![release-charts](https://github.com/teguru-labs/helm-charts/actions/workflows/release.yaml/badge.svg)](https://github.com/teguru-labs/helm-charts/actions/workflows/release.yaml)
[![pages-build-deployment](https://github.com/teguru-labs/helm-charts/actions/workflows/pages/pages-build-deployment/badge.svg?branch=gh-pages)](https://github.com/teguru-labs/helm-charts/actions/workflows/pages/pages-build-deployment)

Teguru's Helm Charts for Kubernetes.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```bash
helm repo add teguru https://charts.teguru.com
helm repo update
```

You can then run `helm search repo instant-chart` to see the charts.
