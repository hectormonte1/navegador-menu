# Changelog

## 1.1.1 — 2026-09-29

- Translate all project documentation and the GitHub description into English.
- Translate menu items, app messages, accessibility text, and browser validation errors into English.
- Set the app development language to English; macOS dialogs retain the system language.

## 1.1.0 — 2026-09-29

First version prepared for public version history.

- Separate the menu, switching logic, and system APIs.
- Test cancellation, partial failures, and concurrent requests without modifying preferences.
- Package each architecture in a ZIP to protect signed bundles from synchronization metadata changes.
- Build for Intel or Apple Silicon with an explicit macOS 13 deployment target.
- Restrict browser identifiers, verify the resulting state, and remove the automatic login-registration argument.
- Keep the menu stable while open and disable actions during a change.
- Omit personal paths from diagnostics and use a project-specific public bundle identifier.
- Support concurrency annotations in older SDKs through the system adapter.
- Add documentation, a security policy, CI, and generated-artifact exclusions.

## Prototypes — 2026-09-29

Initial local Safari/Chrome selector, followed by optional launch at login. These stages predate public Git history and were not published releases.
