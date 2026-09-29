import AppKit

@MainActor
final class WorkspaceBrowserSystem: BrowserSystem {
    func handler(_ scheme: String) -> String? {
        // This URL is only passed to Launch Services for a local association lookup.
        guard ["http", "https"].contains(scheme),
              let probe = URL(string: "\(scheme)://example.invalid"),
              let url = NSWorkspace.shared.urlForApplication(toOpen: probe) else { return nil }
        return Bundle(url: url)?.bundleIdentifier
    }

    func applicationURL(for id: String) -> URL? {
        NSWorkspace.shared.urlForApplication(withBundleIdentifier: id)
    }

    func setDefault(_ application: URL, scheme: String) async throws {
        // Keep NSWorkspace on the main actor, including on older AppKit SDKs.
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            NSWorkspace.shared.setDefaultApplication(at: application, toOpenURLsWithScheme: scheme) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
