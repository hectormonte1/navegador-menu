# Security and privacy

## Scope

Navegador reads local associations and asks macOS to change only the HTTP and HTTPS schemes between two allowed browser identifiers: Safari and Google Chrome. Launch at login requires an explicit user action through ServiceManagement.

The app contains no network requests, telemetry, automatic updates, browsing-history access, password access, or shell-command execution. The `example.invalid` domain is used only to query local associations; it is never opened or visited. Build scripts do run local development tools.

The app does not request Accessibility, Screen Recording, Full Disk Access, or administrator privileges. It contains no keys, distribution certificates, or external dependencies.

## Implemented controls

- An explicit browser allowlist and installation checks.
- Sequential changes with overlapping requests blocked.
- Cancellation and errors stop the sequence; no silent retries or rollbacks.
- Both protocols are checked after a change; a successful callback alone is not considered proof of success.
- Optional launch at login through the menu; the argument that could register it automatically at startup was removed.
- Diagnostics without personal filesystem paths.
- Binaries, caches, logs, environment files, and keys excluded from Git.
- CI with read-only permissions, no persisted credentials, and a commit-pinned action; Dependabot proposes updates.
- Local signing with hardened runtime and no entitlement exceptions.

## Limitations

This is a limited review, not a certification or a guarantee that the app has no vulnerabilities. The app does not use App Sandbox. Ad hoc signing does not establish publisher identity, and hardened runtime does not replace sandboxing or notarization.

Launch Services resolves installed apps by identifier; the app does not independently verify their vendor signatures. It assumes a legitimate system and browser installation. An attacker who already controls the account or device is outside this threat model.

HTTP and HTTPS changes are not atomic: canceling the second confirmation can leave a partial selection, which is explicitly displayed. Automated tests use a simulated system and do not exercise real consent dialogs.

## Before distributing binaries to others

- Validate interaction and launch at login on Intel and Apple Silicon hardware and supported macOS versions.
- Use Developer ID signing, hardened runtime, and Apple notarization; verify the result before publishing.
- Store certificates and credentials only as signing-environment secrets, never in the repository.
- Publish the version, release notes, and artifact checksums.
- Do not ask users to disable Gatekeeper or remove quarantine as an installation workaround.

## Reporting a problem

Do not post credentials, personal information, or exploitable details in a public issue. Use [private vulnerability reporting](https://github.com/hectormonte1/navegador-menu/security/advisories/new), which is enabled for this repository. If unavailable, open an issue requesting a private contact channel without including sensitive findings.

The review of this version is documented in [VALIDATION.md](docs/VALIDATION.md).
