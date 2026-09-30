# Technical decisions

## Swift and AppKit

`NSStatusItem` provides a native menu without a main window. `LSUIElement` prevents a permanent Dock icon. macOS 13 is required for `SMAppService`.

## Source of truth

Launch Services owns browser associations. The app does not persist a separate copy in its preferences: each refresh queries HTTP and HTTPS again. The timer avoids rebuilding the menu while it is open so options do not move under the pointer.

## Testing boundary

`BrowserSystem` abstracts reads and writes. `WorkspaceBrowserSystem` adapts `NSWorkspace`; `BrowserService` implements the switching sequence, browser allowlist, and concurrency guard. Tests inject a simulated system, so they neither open confirmation dialogs nor change preferences.

## Partial changes

The system exposes two independent operations. The sequence stops on error or cancellation and reads back the actual result. It does not automatically undo the first change, because doing so could contradict consent the user just gave.

## Launch at login

Registration happens only through a menu action, using `SMAppService.mainApp`. The system handles any required approval. There is no custom LaunchAgent or direct modification of private preferences.

## Build and distribution

The script uses a temporary directory, cleans up only that directory, and packages the verified app into an architecture-specific ZIP under `build/`. The ZIP prevents synchronization services from injecting metadata into the signed bundle. The script does not install or launch the app, or download dependencies. Local signing is ad hoc with hardened runtime; experimental release ZIPs retain that limitation. A Developer ID signed and notarized release needs separate identity signing and notarization.

## References

- [NSWorkspace: changing associations](https://developer.apple.com/documentation/appkit/nsworkspace/setdefaultapplication(at:toopenurlswithscheme:completion:))
- [SMAppService](https://developer.apple.com/documentation/servicemanagement/smappservice)
