import Foundation

struct Browser: Equatable {
    let name: String
    let id: String

    static let supported = [Browser(name: "Safari", id: "com.apple.Safari"),
                            Browser(name: "Google Chrome", id: "com.google.Chrome")]
}

struct BrowserState: Equatable {
    let http: String?
    let https: String?

    enum Selection { case none, partial, complete }

    func selection(for id: String) -> Selection {
        if http == id && https == id { return .complete }
        if http == id || https == id { return .partial }
        return .none
    }
}

@MainActor
protocol BrowserSystem {
    func handler(_ scheme: String) -> String?
    func applicationURL(for id: String) -> URL?
    func setDefault(_ application: URL, scheme: String) async throws
}

enum BrowserChangeError: LocalizedError {
    case unsupported, missing, busy, incomplete

    var errorDescription: String? {
        switch self {
        case .unsupported: return "Only Safari and Google Chrome are supported."
        case .missing: return "The selected browser is not installed."
        case .busy: return "A browser change is already in progress."
        case .incomplete: return "HTTP and HTTPS still use different browsers. Check the menu status before trying again."
        }
    }
}

@MainActor
final class BrowserService {
    private let system: any BrowserSystem
    private(set) var isChanging = false

    init(system: any BrowserSystem) { self.system = system }

    var state: BrowserState {
        BrowserState(http: system.handler("http"), https: system.handler("https"))
    }

    func change(to id: String) async throws {
        guard !isChanging else { throw BrowserChangeError.busy }
        guard Browser.supported.contains(where: { $0.id == id }) else { throw BrowserChangeError.unsupported }
        guard let application = system.applicationURL(for: id) else { throw BrowserChangeError.missing }
        isChanging = true
        defer { isChanging = false }
        // Stop after any failure/cancellation. Never silently roll back a user-approved change.
        for scheme in ["http", "https"] {
            try Task.checkCancellation()
            if system.handler(scheme) != id {
                try await system.setDefault(application, scheme: scheme)
            }
        }
        guard state.selection(for: id) == .complete else { throw BrowserChangeError.incomplete }
    }
}
