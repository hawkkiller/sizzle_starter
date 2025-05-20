#!/bin/bash

# Run analyze in each package that has a pubspec.yaml file
find app packages -type f -name "pubspec.yaml" -exec dirname {} \; | while read -r dir; do
  if [ -f "$dir/pubspec.yaml" ] && [ -d "$dir/lib" ]; then
    pushd $dir
    flutter analyze . --no-pub
    popd
  fi
done
