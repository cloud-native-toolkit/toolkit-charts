# Toolkit charts

A collection of helm charts used by and/or provided for the Garage Cloud Native Toolkit artifacts

This GitHub repository also serves as a Helm repository, hosting the helm charts via GitHub pages. The url
for the Helm repository is https://ibm-garage-cloud.github.io/toolkit-charts/

To view the helm repo metadata see [index.yaml](https://ibm-garage-cloud.github.io/toolkit-charts/index.yaml)

## Usage

The following commands assume Helm 3. The helm charts can be used with Helm 2 but the syntax is slightly different.

### Register the helm repository

```
helm repo add toolkit-charts https://ibm-garage-cloud.github.io/toolkit-charts/
```

### List the charts in the helm repository

```
helm repo update
helm search repo [keyword]
```

### Work with the helm chart

Render the helm chart to the resource yaml then apply it with kubectl:

```
helm template mychart toolkit-charts/{chart} --namespace {namespace} ... | kubectl apply -n {namespace} -f -
```

Let helm install the chart and manage the releases

```
helm install mychart toolkit-charts/{chart} --namespace {namespace} ...
```

Alternatively, the helm repo can be inlined with the `--repo` argument, skipping the `helm repo add` step

```
helm template mychart {chart} --namespace {namespace} --repo https://ibm-garage-cloud.github.io/toolkit-charts/ ... | kubectl apply -n {namespace} -f -
```
hello
