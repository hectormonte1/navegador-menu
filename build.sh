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
# Copy only the generated app. Never install, launch, or alter system settings here.
ditto --norsrc --noextattr "$app" "$PWD/build/Navegador.app"
# Finder/cloud-sync metadata can invalidate a copied local bundle. Remove only
# FinderInfo from this generated output, never quarantine or system protections.
if xattr "$PWD/build/Navegador.app" | grep -qx com.apple.FinderInfo; then
  xattr -d com.apple.FinderInfo "$PWD/build/Navegador.app"
fi
codesign --verify --strict "$PWD/build/Navegador.app"
echo "Built build/Navegador.app ($arch, macOS 13+)"
