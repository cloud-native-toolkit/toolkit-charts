#!/bin/bash

if [[ -z "${SERVICE}" ]] || [[ -z "${NAMESPACE}" ]]; then
  echo "SERVICE and NAMESPACE are required environment variables" >&2
  exit 1
fi

if [[ -z "${SECRET_NAME}" ]]; then
  SECRET_NAME="${SERVICE}"
fi

csrName=${SERVICE}.${NAMESPACE}

if ! command -v oc 1> /dev/null 2> /dev/null; then
  echo "oc cli not found" >&2
  exit 1
fi

if ! command -v openssl 1> /dev/null 2> /dev/null; then
  echo "openssl cli not found" >&2
  exit 1
fi

if [[ -z "${CERT_DIR}" ]]; then
  CERT_DIR=/tmp/cert
  mkdir -p "${CERT_DIR}"
fi

for _ in $(seq 10); do
  serverCert=$(oc get csr ${csrName} -o jsonpath='{.status.certificate}')
  if [[ -n "${serverCert}" ]]; then
    break
  fi
  sleep 1
done

if [[ -z "${serverCert}" ]]; then
  echo "ERROR: After approving csr ${csrName}, the signed certificate did not appear on the resource. Giving up after 10 attempts." >&2
  exit 1
fi
echo "${serverCert}" | openssl base64 -d -A -out "${CERT_DIR}"/server-cert.pem


# create the secret with CA cert and server cert/key
oc create secret generic ${SECRET_NAME} \
  --from-file=key.pem="${CERT_DIR}"/server-key.pem \
  --from-file=cert.pem="${CERT_DIR}"/server-cert.pem \
  --from-file=tls.key="${CERT_DIR}"/server-key.pem \
  --from-file=tls.crt="${CERT_DIR}"/server-cert.pem \
  --dry-run=client \
  -o yaml | \
  oc -n ${NAMESPACE} apply -f -

if [[ -n "${CA_CONFIG_MAP_NAME}" ]]; then
  oc get cm -n "${NAMESPACE}" kube-root-ca.crt -o jsonpath='{ .data.ca\.crt }' > "${CERT_DIR}/ca.crt"
  oc create configmap ${CA_CONFIG_MAP_NAME} \
    --from-file=ca.crt="${CERT_DIR}/ca.crt" \
    --dry-run=client \
    -o yaml | \
    oc -n "${NAMESPACE}" apply -f -
fi
