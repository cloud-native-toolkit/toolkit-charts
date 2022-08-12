# OpenShift OAuth Config - GitHub

This helm chart provides the configuration required to enable GitHub or GitHub Enterprise as the identity provider for a Red Hat OpenShift cluster. It aims to provide automation in support of these instructions - https://docs.openshift.com/container-platform/4.10/authentication/identity_providers/configuring-github-identity-provider.html

## Usage

### Registering a GitHub application

1. Register an application on GitHub:

    - For GitHub, click Settings → Developer settings → OAuth Apps → Register a new OAuth application.
    
    - For GitHub Enterprise, go to your GitHub Enterprise home page and then click Settings → Developer settings → Register a new application.

2. Enter an application name, for example "OpenShift - {cluster id}".

3. For the Homepage URL provide the url to the OpenShift console.

4. Optional: Enter an application description.

5. Enter the authorization callback URL, where the end of the URL contains the identity provider name:

    ```
    https://oauth-openshift.apps.<cluster-name>.<cluster-domain>/oauth2callback/<idp-provider-name>
    ```

    For example:

    ```
    https://oauth-openshift.apps.openshift-cluster.example.com/oauth2callback/github
    ```

6. Click **Register application**. GitHub provides a client ID and a client secret. You need these values to complete the identity provider configuration.

### Helm install

Once the GitHub OAuth app has been created, the helm chart can be used to create the cluser OAuth configuration. The following information from the previous step is required:

- **idp-provider-name** - the value provided for the idp-provider-name in the callback url
- **clientId** - the generated client id
- **clientSecret** - the generated client secret

Optional values can also be provided to further configure the OAuth entry:

- **organizations** - The list of GitHub organizations whose members should be granted access to the cluster. Organizations can be used independently or combined with teams.
- **teams** - The list of GitHub teams whose members should be granted access to the cluster. The teams are expected to have the format `organization/team`. Teams can be used independently or combined with organizations.
- **hostname** - The hostname of the GitHub Enterprise server
- **caCert** - Value of the ca.crt that signed the SSL certificates for the GitHub Enterprise server

**Note:** The helm chart can only be run in the `openshift-config` namespace

**Note:** List values can be passed in the `--set` argument of helm by wrapping the values in curly braces. E.g. `{value2,value2}` is the equivalent of `["value1","value2"]` in JSON.

Install the chart by running the following command:

```shell
helm install {idp-provider-name} ocp-oauth-github \
  --repo https://charts.cloudnativetoolkit.dev \
  -n openshift-config \
  --set clientId=clientId \
  --set clientSecret=clientSecret \
  --set organizations="{org1,org2}" \
  --set teams="{org1/team1,org1/team2}"
```
