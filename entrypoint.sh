#!/usr/bin/env bash

export PATH=/usr/local/bundle/bin/:$PATH

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

# When the runner maps the $GITHUB_WORKSPACE mount, it is owned by the runner
# user while the created folders are owned by the container user, causing this
# error. Issue description here: https://github.com/actions/checkout/issues/766
git config --global --add safe.directory /github/workspace
git config --global user.name "${INPUT_GIT_PUSH_USER_NAME}"
git config --global user.email "${INPUT_GIT_PUSH_USER_EMAIL}"

gem install caretaker

ls -lsa

git rev-parse --show-toplevel
git config --get remote.origin.url
git --no-pager log --first-parent --oneline --pretty=format:'%h|%H|%d|%s|%cd'

#caretaker --silent --output "${OUTPUT_FILE}"

cat "${OUTPUT_FILE}"

exit 0



git add "${OUTPUT_FILE}"
git commit -m "(docs) Update myfile"
git push
