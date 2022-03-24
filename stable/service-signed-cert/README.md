# Service Signed Cert

Chart to provision a job that does the following:

1. Creates a certificate signing request (CSR) for a service name
2. Automatically approves the CSR
3. Generates a secret with the resulting certificate

## Variables

### Required variables

- `serviceName` - the name of the kubernetes service for which the certificate will be generated
- `secretName` - the name of the secret that will be created to hold the generated TLS certificate

### Optional variables

- `serviceAccount.name` - the name of the service account under which the job will run. The service account name is required but a default value is provided.
- `serviceAccount.create` - flag indicating that the service account should be created. If false then it is assumed the serviceAccount already exists.
- `serviceAccount.rbac` - flag indicating that rbac config for the service account should be provisioned. If false the rbac should be created separately.
