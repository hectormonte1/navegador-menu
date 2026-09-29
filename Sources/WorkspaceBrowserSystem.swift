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
        try await NSWorkspace.shared.setDefaultApplication(at: application, toOpenURLsWithScheme: scheme)
    }
}
