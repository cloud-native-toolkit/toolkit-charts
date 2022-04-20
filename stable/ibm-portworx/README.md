# IBM Portworx chart

Helm chart to provision Portworx in an IBM Cloud OpenShift cluster. Provisioning Portworx involves multiple components so there are multiple resources provisioned.

## Prerequisite

This chart depends on the IBM Cloud Operator deployed via the ibmcloud-operator chart.

## Components

### Config Map

Contains the shell scripts that are used to provision other components.

### DaemonSet

Deploys a DaemonSet to provision a volume and bind it to each node. When the daemon pod receives a SIGTERM then the volume is detached from the node.

### Job

Deploys a job that reads the providerID from the node and generates a secret containing the `clsuterId`. The `clusterId` is needed by the portworx service.

### Secret (optional)

Deploys a secret that contains the IBM Cloud Api Key which is needed by the Portworx Service. The secret can be provisioned by the chart or manually created.

### Portworx Service

Deploys an IBM Cloud Operator Service to provision the portworx instance in the cluster

### Supporting resources

- ServiceAccount - the serviec account for all the resources
- RBAC - configures the necessary permissions for each of the commponents in the chart
