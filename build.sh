#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
arch="${ARCH:-$(uname -m)}"
case "$arch" in arm64|x86_64) ;; *) echo 'ARCH must be arm64 or x86_64' >&2; exit 1;; esac
staging="$(mktemp -d "${TMPDIR:-/tmp}/navegador-build.XXXXXX")"
trap 'rm -rf "$staging"' EXIT
app="$staging/Navegador.app"
mkdir -p "$app/Contents/MacOS" build/module-cache
xcrun swiftc -swift-version 5 -warnings-as-errors -O \
  -target "$arch-apple-macos13.0" -module-cache-path "$PWD/build/module-cache" \
  -framework AppKit -framework ServiceManagement Sources/*.swift \
  -o "$app/Contents/MacOS/Navegador"
cp Resources/Info.plist "$app/Contents/Info.plist"
plutil -lint "$app/Contents/Info.plist"
codesign --force --sign - --options runtime "$app"
codesign --verify --strict "$app"
# Package the verified bundle before a synced directory can add Finder metadata.
# The archive contains only the app; no caches, certificates or source paths.
archive="$PWD/build/Navegador-$arch.zip"
ditto -c -k --norsrc --noextattr --keepParent "$app" "$archive"
unzip -t "$archive" >/dev/null
echo "Built build/Navegador-$arch.zip ($arch, macOS 13+)"
