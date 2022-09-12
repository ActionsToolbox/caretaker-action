#!/bin/sh -l

gem install caretaker

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"
