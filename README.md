# Navegador 🌐

[![Build and test](https://github.com/hectormonte1/navegador-menu/actions/workflows/ci.yml/badge.svg)](https://github.com/hectormonte1/navegador-menu/actions/workflows/ci.yml)

Switch between Safari and Google Chrome from the macOS menu bar.

A small portfolio project built around an everyday need, using native APIs and documenting the journey from prototype to a maintainable app.

```text
🌐 Safari
┌──────────────────────────────────┐
│ ✓ Safari                         │
│   Google Chrome                  │
│ ──────────────────────────────── │
│   Open at Login                  │
│ ──────────────────────────────── │
│   Quit                           │
└──────────────────────────────────┘
```

*Illustrative menu, not a screenshot.*

## Features

- Displays the default browser and lets you choose Safari or Chrome.
- Checks HTTP and HTTPS separately; a partial checkmark means their associations differ.
- Respects macOS confirmation dialogs and cancellations.
- Offers optional launch at login, disabled by default for a new installation.
- Refreshes when you open the menu and every five seconds while it is closed.
- Runs without servers, accounts, analytics, or third-party dependencies.

The app interface and project documentation are in English. Native macOS dialogs and system-provided error details follow your system language.

## Requirements and build

macOS 13 or later. Building requires Xcode Command Line Tools with Swift 5.9 or later (Xcode 15+). Safari ships with macOS; Chrome must be installed to select it.

```bash
bash scripts/test.sh
bash build.sh
```

The output is `build/Navegador-arm64.zip` or `build/Navegador-x86_64.zip`, depending on the architecture. Architecture is detected automatically, or you can select it explicitly:

```bash
ARCH=arm64 bash build.sh    # Apple Silicon
ARCH=x86_64 bash build.sh   # Intel
```

Each build targets one architecture. Building does not install or launch the app, or change system preferences. The minimum macOS version is set explicitly in both the executable and the manifest to prevent accidental compatibility issues.

## Installation and usage

1. Build on the Mac where you intend to use the app.
2. Extract the ZIP for your architecture, copy `Navegador.app` to Applications using Finder, and open it.
3. Click the globe, select a browser, and accept the macOS confirmation if prompted.
4. Optionally enable **Open at Login**. macOS may require approval in System Settings.

Local builds use an **ad hoc** signature and hardened runtime. They are not Developer ID signed or notarized, and are not yet offered as notarized downloads for other users. Do not disable Gatekeeper to install them; see [SECURITY](SECURITY.md).

When upgrading from the prototype, disable its launch-at-login setting and quit it before opening this version. The app now uses a project-specific bundle identifier; running both versions can create duplicate menu items.

**Quit** closes the app without disabling launch at login. To uninstall, disable that option, quit, and move the app to Trash. Your selected default browser remains in place.

## Development and testing

| File | Responsibility |
| --- | --- |
| `Sources/main.swift` | Menu, messages, and launch at login |
| `Sources/BrowserService.swift` | Browser state and testable switching sequence |
| `Sources/WorkspaceBrowserSystem.swift` | macOS API integration |
| `Resources/Info.plist` | App identity and minimum system version |
| `Tests/BrowserServiceTests.swift` | Tests using a simulated system |

Tests do not change real preferences. They cover unknown state, partial and complete selection, missing browsers, unsupported identifiers, unnecessary changes, cancellation, partial failures, callbacks without applied changes, and concurrent requests. GitHub Actions runs the tests and builds both architectures; this does not replace visual testing on Intel and Apple Silicon hardware.

Optional local diagnostics (read-only; no preference changes):

```bash
/Applications/Navegador.app/Contents/MacOS/Navegador --diagnose
```

Adjust the path if you installed the app in your user Applications folder.

Before distribution, manually switch Safari → Chrome → Safari, check both protocols, cancel a confirmation, and verify that the menu reports the actual state. Test launch at login after saving your work. Existing browser tabs and apps that force their own browser are unaffected.

## Project history

Read the [case study](docs/CASE_STUDY.md), [technical decisions](docs/ARCHITECTURE.md), and [changelog](CHANGELOG.md). Git history starts with the version prepared for public release: earlier prototypes are documented, without inventing retroactive commits.

Created by [hectormonte1](https://github.com/hectormonte1), with assistance from Codex. See [CONTRIBUTING](CONTRIBUTING.md) to contribute.

## Reuse permissions

This repository is published as a portfolio project. An open-source license has not yet been selected; public visibility does not automatically grant general reuse permissions.
