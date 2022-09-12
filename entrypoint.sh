#!/bin/sh -l

sh -c "echo $*"

gem install caretaker

/usr/local/bundle/bin/caretaker --output "${1}"
