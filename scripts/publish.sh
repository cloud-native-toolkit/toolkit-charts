#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname "$0"); pwd -P)

TARGET_BRANCH="$1"
PUBLISH_DIR="$2"
REPO_URL="$3"
if [[ -z "${REPO_URL}" ]]; then
  REPO_URL="https://ibm-garage-cloud.github.io/toolkit-charts/"
fi

CHART_DIR="stable"

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"

  git remote set-url origin https://${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}
}

checkout_branch() {
  set -x
  git remote -v
  git checkout -b "${TARGET_BRANCH}" --track "origin/${TARGET_BRANCH}"
}

publish_content() {
  cp ${PUBLISH_DIR}/* "${CHART_DIR}"

  rm -rf "${PUBLISH_DIR}"
}

generate_index() {
  helm repo index "${CHART_DIR}" --url "${REPO_URL}/${CHART_DIR}/" --merge "${CHART_DIR}/index.yaml"
  cp "${CHART_DIR}/index.yaml" .
}

commit_files() {
  git add .
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
#  git remote add origin-pages https://${GH_TOKEN}@github.com/MVSE-outreach/resources.git > /dev/null 2>&1
#  git push --quiet --set-upstream origin-pages gh-pages
   git push
}

setup_git
checkout_branch
publish_content
generate_index
commit_files
upload_files
