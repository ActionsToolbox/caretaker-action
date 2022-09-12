#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o errtrace

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

gem install caretaker

echo "================================"
ls
echo "================================"

#/usr/local/bundle/bin/caretaker --output "${OUTPUT_FILE}"

touch MYFILE


ls
echo "================================"

git add MYFILE
git commit -m "(docs) Update myfile"
git push
