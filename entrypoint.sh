#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o errtrace

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

gem install caretaker

ls

#/usr/local/bundle/bin/caretaker --output "${OUTPUT_FILE}"

touch MYFILE
