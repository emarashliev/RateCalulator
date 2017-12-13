#!/bin/bash

if ! type "carthage" >/dev/null 2>&1; then
  echo "error: Can't find carthage command; make sure you have installed Carthage on your computer."
  echo "You can have it by running 'brew install carthage' or go to https://github.com/Carthage/Carthage#installing-carthage"
  exit 1
fi

set -x
exec carthage update --platform iOS
