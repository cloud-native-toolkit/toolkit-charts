# Namespace helm chart

Helm chart to create a namespace with RBAC necessary to allow ArgoCD to operate within the namespace. Optionally, an operator group will be created in the namespace and/or a configmap will be created to record the gitops repository information.

The chart will create the namespace using the release name provided for the helm execution.

## Values

| Name                                 | Description                                                                          | Default            |
|--------------------------------------|--------------------------------------------------------------------------------------|--------------------|
| **createOperatorGroup**              | Flag indicating the operator group should be created for the namespace               | `true`             |
| **argocdNamespace**                  | The namespace where ArgoCD has been installed. This value is used for the rbac rules | `openshift-gitops` |
| **gitopsConfig.create**              | Flag indicating that the gitops repository configmap should be created               | `false`            |
| **gitopsConfig.applicationBasePath** | The base path in the gitops repo where application configuration should be installed | `""`               | 
| **gitopsConfig.host**                | The host name of the gitops repo                                                     | `""`               |
| **gitopsConfig.org**                 | The org of the gitops repo                                                           | `""`               |
| **gitopsConfig.repo**                | The repo name for the gitops repo                                                    | `""`               |
| **gitopsConfig.repo**                | The branch for the gitops repo                                                       | `main`             |
