#!/usr/bin/env bash

export PATH=/usr/local/bundle/bin/:/usr/lib/gnupg/:$PATH

#set -o errexit
#set -o pipefail
#set -o errtrace

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

    export GPG_TTY=$(tty)

    echo "${GPG_PRIVATE_KEY}" | gpg --batch --import

    echo allow-preset-passphrase >> ~/.gnupg/gpg-agent.conf
    gpg-connect-agent reloadagent /bye
    keygrip=$(gpg-connect-agent -q 'keyinfo --list' /bye | awk '/KEYINFO/ { print $3 }')

    for k in $keygrip
    do
        echo "${GPG_PASSPHRASE}"  | gpg-preset-passphrase --preset $k
    done

    git config --global user.signingkey 06EFF25D4D5BAE4F
    git config --global commit.gpgsign true

    git commit -S -m "${INPUT_GIT_COMMIT_MESSAGE}"
fi

git push

exit 0
