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

caretaker --silent --output "${OUTPUT_FILE}" || true

git add "${OUTPUT_FILE}"

if [[ -z "${GPG_PRIVATE_KEY}" ]] || [[ -z "${GPG_PASSPHRASE}" ]]; then
    echo "No Key + passphrase - will use unsigned cmiits "
    git commit -m "${INPUT_GIT_COMMIT_MESSAGE}"
else
    echo "Key + passphrase given - will sign commits"

echo"1"
    gpg --list-secret-keys

echo"2"
    echo -e "${GPG_PRIVATE_KEY}" > gpg.key

echo"3"
    GPG_TTY=$(tty)
echo"4"
    gpg --allow-secret-key-import --import "gpg.key" --passphrase "${GPG_PASSPHRASE}"
echo"5"

    rm -f  gpg.key
    gpg --list-secret-keys
fi

#git push

exit 0
