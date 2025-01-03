# Get workspace dependencies
flutter pub get

# For each package in packages that has build_runner dependency run build_runner
for dir in packages/*; do
  if [ -f "$dir/pubspec.yaml" ]; then
    if grep -q build_runner "$dir/pubspec.yaml"; then
      pushd $dir
      dart run build_runner build --delete-conflicting-outputs
      popd
    fi
  fi
done