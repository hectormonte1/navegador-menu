#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build/module-cache
xcrun swiftc -swift-version 5 -warnings-as-errors -parse-as-library \
  -target "$(uname -m)-apple-macos13.0" -module-cache-path "$PWD/build/module-cache" \
  Sources/BrowserService.swift Tests/BrowserServiceTests.swift -o build/BrowserServiceTests
build/BrowserServiceTests
