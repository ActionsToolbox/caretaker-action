#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o errtrace

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

if [ -z "${INPUT_GIT_PUSH_USER_NAME}" ]; then
    INPUT_GIT_PUSH_USER_NAME="github-actions[bot]"
fi

if [ -z "${INPUT_GIT_PUSH_USER_EMAIL}" ]; then
    INPUT_GIT_PUSH_USER_EMAIL="github-actions[bot]@users.noreply.github.com"
fi


gem install caretaker

echo "================================"
ls
echo "================================"

#/usr/local/bundle/bin/caretaker --output "${OUTPUT_FILE}"

touch MYFILE


ls
echo "================================"

   # When the runner maps the $GITHUB_WORKSPACE mount, it is owned by the runner
    # user while the created folders are owned by the container user, causing this
    # error. Issue description here: https://github.com/actions/checkout/issues/766
    git config --global --add safe.directory /github/workspace

    git config --global user.name "${INPUT_GIT_PUSH_USER_NAME}"
    git config --global user.email "${INPUT_GIT_PUSH_USER_EMAIL}"


git add MYFILE
git commit -m "(docs) Update myfile"
git push
