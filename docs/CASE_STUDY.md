# From an everyday problem to a portfolio project

## The need

Switch between Safari and Chrome without opening System Settings each time. The result is a small menu bar utility that keeps the current state visible.

## Evolution

1. **Prototype:** a globe, browser name, and a choice of two browsers.
2. **Compatibility:** an initial build inherited a macOS requirement newer than the target device. The fix was to set the deployment target explicitly; the current process also selects the architecture.
3. **Daily use:** optional launch at login and separate reporting when HTTP and HTTPS associations differ.
4. **Public preparation:** separation of responsibilities, tests, removal of private references, and automated builds.

## What this project demonstrates

- Turning a specific need into a small native utility.
- Integrating system APIs while respecting user decisions.
- Modeling partial operations and failures without reporting false success.
- Maintaining testable code, documentation, and an honest version history.

The implementation was developed with assistance from Codex. It is not a browser, proxy, extension, or remote service.

## Remaining work

Full manual testing of this revision, Developer ID signing and notarization for distribution, a license decision, and live screenshots without personal information. The README now includes an illustrated demo using fictional messages, plus experimental release downloads. No performance or security metrics are claimed without measurement.
