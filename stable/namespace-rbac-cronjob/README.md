# ArgoCD RBAC Cronjob chart

This helm chart provisions a cronjob in a cluster that runs frequently (every 5 minutes by default) in search of namespace resources that contain a label indicating that the ArgoCD service account should be granted permission to deploy other resources. A default RBAC configuration is provided for the namespace and can be customized using an annotation.

**Note:** This cronjob is a poor-man's admission controller or operator and may eventually be replaced to be a bit more efficient. If nothing else this logic shows that there is more than one way to implement logic in a cluster and that not everything needs to be an operator.

## Values

| Value                 | Description                                                                | Default           |
|-----------------------|----------------------------------------------------------------------------|-------------------|
| rbac                  | Flag indicating the RBAC configuration should be generated for the cronjob            | `true` |
| targetLabel           | The label that will be matched on the namespace to generate RBAC                      |  |
| targetNamespace       | The namespace of the service account that will be granted permission to the namespace |  |
| targetServiceAccount  | The service account that will be granted permission to the namespace                  |  |
| defaultRules          | The default RBAC rules that will be granted to the service account                    |  |
| schedule              | The schedule for the cron job - https://crontab.guru/                                 | "*/5 * * * *" |
| serviceAccount.create | Flag indicating that a service account for the cronjob should be created              | `true` |
| serviceAccount.name   | The name of the service account. If not provided it defaults to the full name of the chart | |
| image                 | The image the cronjob pods should use                                                 | `quay.io/cloudnativetoolkit/console-link-cronjob` |
| imageTag              | The imageTag that should be used for the image.                                       | `v0.1.0` |

## Labels and annotations

A label marks the namespaces for which the console link should be created. Annotations provide the configuration values for the generated RBAC entry.

**Note:** Labels in kubernetes are indexed in the etcd database and therefore provide a mechanism to optimize the search for resource in the cluster. A label has been used in this case to mark the resources so we are able to do an indexed search for the resources instead of what amounts to a table scan across the cluster.

### Label

The cronjob searches for all namespaces that have the label defined by the `targetLabel` value with a value of `true`. To enable the generation of RBAC for a particular resource, simply add or remove the label (or change the value to `false`).

## Development

The shell scripts executed by the cronjob can be found in the scripts/ folder. Locating the scripts here makes it easier to test the logic. When the scripts have been tested and the logic is ready to be deployed, the scripts/_update-configmap.sh shell script can be used to update the script logic located in the config map template. The "header" of the config map template can be found in the support/ folder.

When the job starts, the contents of the config map are mounted as a volume and the shell scripts are available as executables in the pod.

Both the scripts/ and support/ folders have been added to .helmignore so the files don't get packaged with the helm chart.
