#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)
ROOT_DIR=$(cd "${SCRIPT_DIR}/.."; pwd -P)

RELEASE_DIR="$1"
if [[ -z "${RELEASE_DIR}" ]]; then
  RELEASE_DIR="${ROOT_DIR}/tmp"
fi

CHART_DIR="${ROOT_DIR}/stable"

mkdir -p "${RELEASE_DIR}"

cd "${RELEASE_DIR}"

ls "${CHART_DIR}" | while read chart; do
  echo "chart: $chart"
  helm package "${CHART_DIR}/${chart}"
done

cd "${ROOT_DIR}"
