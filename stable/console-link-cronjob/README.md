# Console Link Cronjob chart

This helm chart provisions a cronjob in a cluster that runs frequently (every 5 minutes by default) in search of resources that should be used to generate a ConsoleLink (and optionally a ConfigMap). Generally, there are two challenges associated with creating ConsoleLinks in a declarative manner: 1) permissions to create console-level resources and 2) the dynamic nature of some of the endpoints, particularly the url of the route. The cronjob created by this module scans the deployed resources and generates the resources accordingly.

**Note:** This cronjob is a poor-man's admission controller or operator and may eventually be replaced to be a bit more efficient. If nothing else this logic shows that there is more than one way to implement logic in a cluster and that not everything needs to be an operator.

## Use cases

There are three different use cases addressed by the cronjob:

1. Resources hosted inside the cluster - create a ConsoleLink and ConfigMap from a Route
2. Resources hosted outside the cluster - create a ConsoleLink from a ConfigMap
2. Resources attached to the cluster - create a ConsoleLink and ConfigMap when a Logdna or Sysdig agent are installed into the cluster

Labels and annotations control the behavior of the cronjob and the resources that are created for the first two use cases. The LogDNA and Sysdig behavior is dictated by the existence of the daemonsets in the `ibm-observe` namespace and environment variables defined on the cronjob.

## Labels and annotations

A label marks the routes and config maps for which the console link should be created. Annotations provide the configuration values for the generated console link.

**Note:** Labels in kubernetes are indexed in the etcd database and therefore provide a mechanism to optimize the search for resource in the cluster. A label has been used in this case to mark the resources so we are able to do an indexed search for the resources instead of what amounts to a table scan across all the namespaces.

### Label

The cronjob searches for all routes and config maps that have the label `console-link.cloud-native-toolkit.dev/enabled` with a value of `true`. To enable the generation of the console link for a particular resource, simply add or remove the label (or change the value to `false`).

| Label                                    | Description                                                                | Value             |
|-----------------------------------------------|----------------------------------------------------------------------------|-------------------|
| console-link.cloud-native-toolkit.dev/enabled | Flag indicating that a console link should be generated from this resource | "true" or "false" |

### Annotations

The following annotations control the values that are provided for the generated console link. See https://docs.openshift.com/container-platform/4.7/rest_api/console_apis/consolelink-console-openshift-io-v1.html for an overview of the attributes of a console link.

| Label | Description | Value |
|-------|-------------|-------|
| console-link.cloud-native-toolkit.dev/section     | The section heading where the console link should appear in the menu. If not provided the cronjob will look for an environment variable named DEFAULT_SECTION. If the environment variable is not set the value will default to "Cloud-Native Toolkit" | "Cloud-Native Toolkit" |
| console-link.cloud-native-toolkit.dev/location    | The location of the console link item. If not provided the cronjob will look for an environment variable named DEFAULT_LOCATION. If the environment variable is not set the value will default to "ApplicationMenu" | ApplicationMenu, HelpMenu, UserMenu, or NamespaceDashboard |
| console-link.cloud-native-toolkit.dev/imageUrl    | The url of the image that will appear in the menu. The value can either be an https url or a `data:` value. If not provided then no image will be used |   |
| console-link.cloud-native-toolkit.dev/displayName | The display name that will appear in the menu. If not provided the value will default to the name in the resource |   |
| console-link.cloud-native-toolkit.dev/category    | The category or grouping of the tool (e.g. artifact-management, static-analysis, security). Currently this value is not used in the console link |   |

### Examples

**Route**

```yaml
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  labels:
    console-link.cloud-native-toolkit.dev/enabled: "true"
  annotations:
    console-link.cloud-native-toolkit.dev/section: Cloud-Native Toolkit
    console-link.cloud-native-toolkit.dev/location: ApplicationMenu
    console-link.cloud-native-toolkit.dev/displayName: Pact Broker
    console-link.cloud-native-toolkit.dev/imageUrl: data:image/png;base64,...
  name: pact-broker
spec:
  host: pact-broker-tools.ocp47-test2-4be51d31de4db1e93b5ed298cdf6bb62-0000.us-south.containers.appdomain.cloud
  port:
    targetPort: http
  tls:
    insecureEdgeTerminationPolicy: Redirect
    termination: edge
  to:
    kind: Service
    name: pact-broker
    weight: 100
  wildcardPolicy: None
```

**Config Map**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    console-link.cloud-native-toolkit.dev/enabled: "true"
  annotations:
    console-link.cloud-native-toolkit.dev/section: Cloud-Native Toolkit
    console-link.cloud-native-toolkit.dev/location: ApplicationMenu
    console-link.cloud-native-toolkit.dev/displayName: IBM Container Registry
    console-link.cloud-native-toolkit.dev/imageUrl: data:image/png;base64,...
  name: registry-config
data:
  url: https://cloud.ibm.com/registry/namespaces?region=eu-central
```

## Development

The shell scripts executed by the cronjob can be found in the scripts/ folder. Locating the scripts here makes it easier to test the logic. When the scripts have been tested and the logic is ready to be deployed, the scripts/_update-configmap.sh shell script can be used to update the script logic located in the config map template. The "header" of the config map template can be found in the support/ folder.

When the job starts, the contents of the config map are mounted as a volume and the shell scripts are available as executables in the pod.

Both the scripts/ and support/ folders have been added to .helmignore so the files don't get packaged with the helm chart.
