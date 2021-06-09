# Toolkit charts

A collection of helm charts used by and/or provided for the Garage Cloud Native Toolkit artifacts

This GitHub [cloud-native-toolkit/toolkit-charts](https://github.com/cloud-native-toolkit/toolkit-charts) repository also serves as a Helm repository, hosting the helm charts via GitHub pages.

The url for the Helm repository is [charts.cloudnativetoolkit.dev](https://charts.cloudnativetoolkit.dev)

To view the helm repo metadata see [index.yaml](https://charts.cloudnativetoolkit.dev/index.yaml)

## Usage

The following commands assume Helm 3. The helm charts can be used with Helm 2 but the syntax is slightly different.

### Register the helm repository

```
helm repo add toolkit-charts https://charts.cloudnativetoolkit.dev
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
helm template mychart {chart} --namespace {namespace} --repo https://charts.cloudnativetoolkit.dev ... | kubectl apply -n {namespace} -f -
```
