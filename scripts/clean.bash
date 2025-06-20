# Clean workspace
flutter clean

# Clean packages
for dir in core feature; do
  if [ -f "$dir/pubspec.yaml" ]; then
    pushd $dir
    flutter clean
    popd
  fi
done