#!/usr/bin/env bash
PROJECT_DIR="./simple_live_app"
echo "Building macOS release for project: $PROJECT_DIR"

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter not found in PATH. Install Flutter and add to PATH." >&2
  exit 1
fi

pushd "$PROJECT_DIR" || exit 1

echo "Running flutter pub get..."
flutter pub get || { echo "pub get failed"; popd; exit 1; }

echo "Enabling macOS desktop support (if not already)..."
flutter config --enable-macos-desktop || true

echo "Starting flutter build macos --release"
flutter build macos --release || { echo "build failed"; popd; exit 1; }

OUT_DIR="build_artifacts/macos"
mkdir -p "$OUT_DIR"
echo "Copying .app to $OUT_DIR"
cp -R build/macos/Build/Products/Release/*.app "$OUT_DIR/" || echo ".app copy may have failed, check path"

popd
echo "Done."
