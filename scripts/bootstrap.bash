#!/bin/bash
# Get workspace dependencies
flutter pub get

# For each package that has a pubspec.yaml file and build_runner dependency
# run generation
find . -type f -name "pubspec.yaml" -exec grep -q build_runner {} \; -exec dirname {} \; | while read -r dir; do
  if [ -f "$dir/pubspec.yaml" ]; then
    pushd $dir
    printf "\nGenerating files for $dir\n"
    dart run build_runner build -d
    popd
  fi
done
