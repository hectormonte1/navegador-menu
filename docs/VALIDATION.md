# Validation — 2026-09-29

## Verified locally

- All 12 logic checks passed using a simulated system.
- Native arm64 and cross-compiled x86_64 builds completed with warnings treated as errors.
- The manifest, macOS 13 deployment target, and ad hoc signature with hardened runtime were verified during the build.
- Code review and pattern searches for private keys, GitHub tokens, AWS keys, personal paths, and private references found no matches in the files prepared for publication.
- Binaries and caches are excluded from version history.
- Shell-script syntax was checked.

## Issues fixed during review

The synchronized directory added FinderInfo metadata to the copied bundle, causing signature verification to fail. Removing the attribute was not enough: the synchronization service recreated it. The script now verifies the app in a local temporary directory and packages it into an architecture-specific ZIP instead of copying the unpacked bundle into the synchronized directory. It does not remove quarantine or disable Gatekeeper.

The first CI run passed the logic tests but detected an `NSWorkspace` isolation warning in the runner's SDK. The adapter was changed to wrap the callback API in a continuation, keeping the call on the main actor without relaxing `warnings-as-errors`.

## Verified on GitHub

- [Successful Build and test run](https://github.com/hectormonte1/navegador-menu/actions/runs/36622368028) for commit `215da8a`: logic tests and arm64/x86_64 builds completed.
- Secret scanning and push protection enabled.
- Private vulnerability reporting enabled.
- Source files published without credentials; distribution ZIPs are attached separately to the v1.1.1 release.
- Additional local verification: both ZIPs were extracted and their ad hoc signatures passed strict verification.

## Not yet verified

- Full visual interaction and real confirmation dialogs for this revision.
- Execution on Intel hardware: an Intel build was produced but not tested on an Intel device.
- Actual login, logout, and restart behavior with this revision.
- Developer ID signing and Apple notarization.
- Downloaded-app execution on another Mac with Gatekeeper enabled.

This review does not replace an independent security audit. The tests did not modify the user's browser associations.
