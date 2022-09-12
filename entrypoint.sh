#!/bin/sh -l

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

#gem install caretaker

#/usr/local/bundle/bin/caretaker --output "${1}"

sh -c "echo $*"
