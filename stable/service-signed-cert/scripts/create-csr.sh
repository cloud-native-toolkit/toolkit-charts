#!/bin/bash

if [[ -z "${SERVICE}" ]] || [[ -z "${NAMESPACE}" ]]; then
  echo "SERVICE and NAMESPACE are required environment variables" >&2
  exit 1
fi

csrName=${SERVICE}.${NAMESPACE}

echo "creating certs in CERT_DIR ${CERT_DIR} "

if ! command -v openssl 1> /dev/null 2> /dev/null; then
  echo "openssl cli not found" >&2
  exit 1
fi

if ! command -v oc 1> /dev/null 2> /dev/null; then
  echo "oc cli not found" >&2
  exit 1
fi

if [[ -z "${CERT_DIR}" ]]; then
  CERT_DIR=/tmp/cert
  mkdir -p "${CERT_DIR}"
fi

cat <<EOF >> "${CERT_DIR}"/csr.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${SERVICE}.${NAMESPACE}.svc.cluster.local
DNS.2 = ${SERVICE}
DNS.3 = ${SERVICE}.${NAMESPACE}
DNS.4 = ${SERVICE}.${NAMESPACE}.svc
DNS.5 = *.${SERVICE}.${NAMESPACE}.svc.cluster.local
EOF

openssl genrsa -out "${CERT_DIR}"/server-key.pem 2048
openssl req -new -key "${CERT_DIR}"/server-key.pem -subj "/CN=${SERVICE}.${NAMESPACE}.svc" -out "${CERT_DIR}"/server.csr -config "${CERT_DIR}"/csr.conf

# clean-up any previously created CSR for our service. Ignore errors if not present.
echo "Deleting existing csr ${csrName}, if present"
oc delete csr ${csrName} 2>/dev/null || true

echo "Creating csr ${csrName} for cert "${CERT_DIR}"/server.csr"
cat <<EOF | oc create -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${csrName}
spec:
  groups:
    - system:authenticated
  request: $(< "${CERT_DIR}"/server.csr base64 | tr -d '\n')
  usages:
    - digital signature
    - key encipherment
    - server auth
EOF

#echo "Verifying csr has been created"
#while true; do
#  if oc get csr ${csrName}; then
#    break
#  fi
#done
