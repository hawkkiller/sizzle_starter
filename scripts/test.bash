#!/bin/bash

# Enable error handling
set -e

# Find directories with a pubspec.yaml and a test/ folder
find_test_dirs() {
  find . -type f -name "pubspec.yaml" -exec dirname {} \; | while read -r dir; do
    if [ -d "$dir/test" ]; then
      echo "$dir"
    fi
  done
}

# Capture the output of find_test_dirs and pass it to flutter test
test_dirs=$(find_test_dirs)
if [ -n "$test_dirs" ]; then
  flutter test $test_dirs --no-pub --coverage --file-reporter json:reports/tests.json
else
  echo "No directories with pubspec.yaml and test/ folder found."
fi
