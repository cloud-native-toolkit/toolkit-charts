# IBM Cloud Operator chart

Helm chart to provision the IBM Cloud operator. In addition to creating the subscription, the chart will also create a config map that defines the configuration namespace. 

## Configuration

In the configuration namespace, create the following configuration resources:

```
<namespace>-ibmcloud-operator-secret
<namespace>-ibmcloud-operator-defaults
```

where `<namespace>` is the target namespace where the operator resources will be provisioned.

### ibmcloud-operator-secret

`ibmcloud-operator-secret` is a secret that provides the api key and default region for the operator. The secret should contain the following values:

| Field  | Required | Type | Description |
|--------|----------|------|-------------|
| api-key | Yes | string | The api key that will be used to authenticate the operator with the IBM Cloud account |
| region | Yes | string | The default region for resources provisioned by the operator. This value can be overridden in the `ibmcloud-operator-defaults` config map and/or the operator Service instance. |

### ibmcloud-operator-defaults

`ibmcloud-operator-defaults` is an optional config map that will provide defaults for the CR instances. The config map can contain the following values:

| Field            | Required | Type    | Description                                                                                                                          |
|------------------|----------|---------|--------------------------------------------------------------------------------------------------------------------------------------|
| org	             | No       | string  | The Cloud Foundry org. To list orgs, run ibmcloud account orgs.                                                                      |
| space            | No       | string	 | The Cloud Foundry space. To list spaces, run ibmcloud account spaces.                                                                |
| region           | No       | string  | The IBM Cloud region. To list regions, run ibmcloud regions.                                                                         |
| resourceGroup    | No       | string  | The IBM Cloud resource group name. You must also include the resourceGroupID. To list resource groups, run ibmcloud resource groups. |
| resourceGroupID  | No       | string  | The IBM Cloud resource group ID. You must also include the resourceGroup. To list resource groups, run ibmcloud resource groups.     |
| resourceLocation | No       | string  | The location of the resource.                                                                                                        |
