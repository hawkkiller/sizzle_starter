#!/bin/bash

# Run dart format in all packages of the project that have a pubspec.yaml file
find app core feature -type f -name "pubspec.yaml" -exec dirname {} \; | while read -r dir; do
  if [ -f "$dir/pubspec.yaml" ]; then
    pushd $dir
    printf "\nFormatting $dir\n"

    dirs=(lib test)

    targets=()
    for d in "${dirs[@]}"; do
      [[ -d $d ]] && targets+=("$d")
    done

    # Only run find if at least one target exists
    if ((${#targets[@]})); then
      find "${targets[@]}" \
        -name '*.dart' ! -name '*.*.dart' \
        -exec dart format --line-length 100 {} +
    fi
    popd
  fi
done
