#!/usr/bin/env bash

#export PATH=/usr/local/bundle/bin/:/usr/lib/gnupg/:$PATH
export PATH=/usr/libexec/:$PATH

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
git config --global pull.rebase false

CURRENT_TAG=$(git name-rev --name-only --tags HEAD)
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)

if [[ "${CURRENT_TAG}" == "undefined" ]]; then
    #
    # We are on a branch
    #
    DESTINATION="${CURRENT_BRANCH}"
    PULL_FROM="${CURRENT_BRANCH}"

else
    #
    # We are on a tag and need to push to head of default
    #
    DESTINATION="HEAD:${DEFAULT_BRANCH}"
    PULL_FROM="${DEFAULT_BRANCH}"
fi

git fetch origin "${PULL_FROM}"
git pull origin "${PULL_FROM}"

#gem install caretaker

caretaker --silent --output "${OUTPUT_FILE}" || true

git add "${OUTPUT_FILE}"

if [[ -z "${GPG_PRIVATE_KEY}" ]] || [[ -z "${GPG_PASSPHRASE}" ]]; then
    echo "No Key + passphrase - will use unsigned cmiits "

    git commit -m "${INPUT_GIT_COMMIT_MESSAGE}"
else
    echo "Key + passphrase given - will sign commits"

    #export GPG_TTY=$(tty)

    echo "${GPG_PRIVATE_KEY}" | gpg --batch --import >> /dev/null 2>&1

    echo allow-preset-passphrase >> ~/.gnupg/gpg-agent.conf
    gpg-connect-agent reloadagent /bye
    keygrip=$(gpg-connect-agent -q 'keyinfo --list' /bye | awk '/KEYINFO/ { print $3 }')

    for k in $keygrip
    do
        echo "${GPG_PASSPHRASE}"  | gpg-preset-passphrase --preset "${k}"
    done

    KEY=$(gpg --list-secret-keys --keyid-format LONG caretaker-bot@wolfsoftware.com | head -2 | tail -1)
    KEY=${KEY//[[:blank:]]/}

    git config --global user.signingkey "${KEY}"
    git config --global commit.gpgsign true

    git commit -S -m "${INPUT_GIT_COMMIT_MESSAGE}"
fi

echo "git push origin ${DESTINATION}"
git push origin "${DESTINATION}"

exit 0
