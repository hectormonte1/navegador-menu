# Contributing

1. Describe the problem in an issue without including personal information.
2. Create a branch from `main` and keep each change focused.
3. Run `bash scripts/test.sh` and `bash build.sh`.
4. If you change system integration, complete the manual checks in the README.
5. Update the documentation and CHANGELOG when behavior changes.
6. Open a pull request describing the problem, solution, and validation performed.

Do not commit compiled apps, caches, credentials, personal filesystem paths, or desktop screenshots containing private information. Justify any new dependencies, network access, privileges, or telemetry. Do not bypass macOS confirmation dialogs.

Use descriptive commits, such as `fix: respect cancellation when switching browsers`, `feat: ...`, or `docs: ...`. History should reflect real work; do not reconstruct dates or claim unverified results.

Write project documentation, commit messages, and pull request descriptions in English. Preserve exact interface labels where needed to help users find a control.

A reuse license is still pending the owner's decision.
