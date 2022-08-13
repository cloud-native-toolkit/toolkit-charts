# OpenShift OAuth config - htpasswd

This helm chart provides the configuration required to configure users and passwords in an htpasswd identity provider for a Red Hat OpenShift cluster. It aims to provide automation in support of these instructions - https://docs.openshift.com/container-platform/4.10/authentication/identity_providers/configuring-htpasswd-identity-provider.html

## Usage

The chart does not have any external dependencies. The following options are available:

- **users** - the list of users (and their passwords) who will be added to the htpasswd database. The format for each entry in the list is `name: {username}, password: {password}`
- **defaultPassword** - the default password that will be set for a user if one has not been provided otherwise

1. Create a file named `values.yaml` and add the user configuration. For example:

    ```yaml
    users:
      - name: user1
        password: password1
      - name: user2
        password: password2
    
    defaultPassword: password
    ```

    **Note:** If you want each user to have the same password then exclude the password entry for each user

2. Install the helm chart with the following:

    ```shell
    helm install {idp-provider-name} ocp-oauth-htpasswd \
      --repo https://charts.cloudnativetoolkit.dev \
      -n openshift-config \
      -f values.yaml
    ```
