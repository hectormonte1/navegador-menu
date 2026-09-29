import Foundation

@MainActor
final class FakeSystem: BrowserSystem {
    var handlers = ["http": "com.apple.Safari", "https": "com.apple.Safari"]
    var installed = true
    var failOn: String?
    var applyChanges = true
    var calls: [String] = []
    var beforeSet: (() async throws -> Void)?
    func handler(_ scheme: String) -> String? { handlers[scheme] }
    func applicationURL(for id: String) -> URL? { installed ? URL(fileURLWithPath: "/mock/\(id)") : nil }
    func setDefault(_ application: URL, scheme: String) async throws {
        calls.append(scheme)
        try await beforeSet?()
        if scheme == failOn { throw CancellationError() }
        if applyChanges { handlers[scheme] = application.lastPathComponent }
    }
}

@main
struct BrowserServiceTests {
    @MainActor
    static func main() async throws {
        let safari = "com.apple.Safari", chrome = "com.google.Chrome"
        var passed = 0
        func check(_ condition: Bool, _ message: String) {
            guard condition else { fatalError("FAIL: \(message)") }
            passed += 1
            print("PASS: \(message)")
        }
        check(BrowserState(http: nil, https: nil).selection(for: safari) == .none, "unknown associations are not selected")
        check(BrowserState(http: safari, https: chrome).selection(for: safari) == .partial, "mixed associations are partial")
        check(BrowserState(http: safari, https: safari).selection(for: safari) == .complete, "matching associations are complete")

        let system = FakeSystem()
        let subject = BrowserService(system: system)
        try await subject.change(to: safari)
        check(system.calls.isEmpty, "already selected browser does not prompt")
        try await subject.change(to: chrome)
        check(system.calls == ["http", "https"] && subject.state.selection(for: chrome) == .complete, "changes both schemes sequentially")

        let partial = FakeSystem()
        partial.handlers["http"] = chrome
        try await BrowserService(system: partial).change(to: chrome)
        check(partial.calls == ["https"], "only requests the missing association")

        let cancelled = FakeSystem()
        cancelled.failOn = "http"
        let cancelledService = BrowserService(system: cancelled)
        do { try await cancelledService.change(to: chrome); fatalError("Expected cancellation") } catch is CancellationError {}
        check(cancelled.calls == ["http"] && !cancelledService.isChanging, "cancellation stops later requests and clears busy state")

        let secondFailure = FakeSystem()
        secondFailure.failOn = "https"
        let partialService = BrowserService(system: secondFailure)
        do { try await partialService.change(to: chrome); fatalError("Expected cancellation") } catch is CancellationError {}
        check(partialService.state.selection(for: chrome) == .partial, "second cancellation preserves and reports actual partial state")

        let unavailable = FakeSystem()
        unavailable.installed = false
        do { try await BrowserService(system: unavailable).change(to: chrome); fatalError("Expected missing browser") } catch BrowserChangeError.missing {}
        check(unavailable.calls.isEmpty, "missing browser cannot change settings")
        do { try await subject.change(to: "untrusted.app"); fatalError("Expected unsupported browser") } catch BrowserChangeError.unsupported {}
        check(system.calls.count == 2, "unsupported identifiers cannot change settings")

        let silent = FakeSystem()
        silent.applyChanges = false
        do { try await BrowserService(system: silent).change(to: chrome); fatalError("Expected incomplete change") } catch BrowserChangeError.incomplete {}
        check(silent.handlers["http"] == safari, "success callback alone is not treated as completed change")

        let concurrent = FakeSystem()
        let concurrentService = BrowserService(system: concurrent)
        var rejected = false
        concurrent.beforeSet = {
            do { try await concurrentService.change(to: safari); fatalError("Expected busy") } catch BrowserChangeError.busy { rejected = true }
        }
        try await concurrentService.change(to: chrome)
        check(rejected && concurrent.calls == ["http", "https"], "overlapping requests cannot interleave")
        print("\(passed) checks passed. No system preferences were changed.")
    }
}
