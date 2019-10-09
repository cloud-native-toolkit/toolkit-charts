#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)
ROOT_DIR=$(cd "${SCRIPT_DIR}/.."; pwd -P)

TMP_DIR="${ROOT_DIR}/tmp"
CHART_DIR="${ROOT_DIR}/stable"

mkdir -p "${TMP_DIR}"

cd "${TMP_DIR}"

ls "${CHART_DIR}" | while read chart; do
  echo "chart: $chart"
  helm package "${CHART_DIR}/${chart}"
done

cd "${ROOT_DIR}"

git checkout gh-pages

cp "${TMP_DIR}/*" "${CHART_DIR}"

helm repo index "${CHART_DIR}" --url "https://ibm-garage-cloud.github.io/catalyst-charts/stable/" --merge "${CHART_DIR}/index.yaml"
cp "${CHART_DIR}/index.yaml" "${ROOT_DIR}"

rm -rf "${TMP_DIR}"
