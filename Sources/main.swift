import AppKit
import ServiceManagement

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    let browsers = Browser.supported
    let system = WorkspaceBrowserSystem()
    lazy var service = BrowserService(system: system)
    var statusItem: NSStatusItem!
    let menu = NSMenu()
    var timer: Timer?
    var changing = false
    var menuIsOpen = false

    func handler(_ scheme: String) -> String? {
        system.handler(scheme)
    }

    func name(_ id: String?) -> String {
        guard let id else { return "Sin determinar" }
        if let browser = browsers.first(where: { $0.id == id }) { return browser.name }
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: id) else { return id }
        return FileManager.default.displayName(atPath: url.path).replacingOccurrences(of: ".app", with: "")
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        if CommandLine.arguments.contains("--diagnose") {
            print("HTTP: \(handler("http") ?? "unknown")")
            print("HTTPS: \(handler("https") ?? "unknown")")
            print("Login status: \(SMAppService.mainApp.status.rawValue) (1 = enabled)")
            for browser in browsers {
                print("\(browser.name): \(NSWorkspace.shared.urlForApplication(withBundleIdentifier: browser.id) == nil ? "missing" : "installed")")
            }
            NSApp.terminate(nil)
            return
        }
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.image = NSImage(systemSymbolName: "globe", accessibilityDescription: "Navegador predeterminado")
        statusItem.button?.imagePosition = .imageLeading
        menu.delegate = self
        menu.autoenablesItems = false
        statusItem.menu = menu
        refresh()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                guard let self, !self.menuIsOpen else { return }
                self.refresh()
            }
        }
        timer?.tolerance = 2
    }

    func menuWillOpen(_ menu: NSMenu) { menuIsOpen = true; refresh() }

    func menuDidClose(_ menu: NSMenu) { menuIsOpen = false }

    func applicationWillTerminate(_ notification: Notification) { timer?.invalidate() }

    func refresh() {
        let state = service.state
        let http = state.http, https = state.https
        let title = http == https ? name(https) : "HTTP/HTTPS distintos"
        statusItem.button?.title = " " + (changing ? "Cambiando…" : title)
        statusItem.button?.toolTip = "HTTP: \(name(http)) · HTTPS: \(name(https))"
        menu.removeAllItems()
        for browser in browsers {
            let item = NSMenuItem(title: browser.name, action: #selector(selectBrowser(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = browser.id
            switch state.selection(for: browser.id) {
            case .complete: item.state = .on
            case .partial: item.state = .mixed
            case .none: item.state = .off
            }
            item.isEnabled = !changing && NSWorkspace.shared.urlForApplication(withBundleIdentifier: browser.id) != nil
            menu.addItem(item)
        }
        if http != https {
            menu.addItem(.separator())
            for text in ["HTTP: \(name(http))", "HTTPS: \(name(https))"] {
                let item = NSMenuItem(title: text, action: nil, keyEquivalent: "")
                item.isEnabled = false
                menu.addItem(item)
            }
        }
        menu.addItem(.separator())
        let login = NSMenuItem(title: SMAppService.mainApp.status == .requiresApproval ? "Autorizar inicio de sesión…" : "Abrir al iniciar sesión", action: #selector(toggleLogin), keyEquivalent: "")
        login.target = self
        login.isEnabled = !changing
        login.state = SMAppService.mainApp.status == .enabled ? .on : .off
        menu.addItem(login)
        menu.addItem(.separator())
        let quit = NSMenuItem(title: "Salir", action: #selector(quitApp), keyEquivalent: "q")
        quit.target = self
        quit.isEnabled = !changing
        menu.addItem(quit)
    }

    @objc func selectBrowser(_ sender: NSMenuItem) {
        guard !changing, let id = sender.representedObject as? String else { return }
        changing = true
        refresh()
        Task { @MainActor in
            defer { changing = false; refresh() }
            do {
                try await service.change(to: id)
            } catch {
                show("No se completó el cambio", "Si cancelaste la confirmación, se respetó tu decisión.\n\nHTTP: \(name(handler("http")))\nHTTPS: \(name(handler("https")))\n\n\(error.localizedDescription)")
            }
        }
    }

    func enableLogin() {
        do {
            if SMAppService.mainApp.status != .enabled && SMAppService.mainApp.status != .requiresApproval {
                try SMAppService.mainApp.register()
            }
            if SMAppService.mainApp.status == .requiresApproval {
                show("Autoriza el inicio automático", "Activa Navegador en Ajustes del Sistema > General > Ítems de inicio y extensiones.")
                SMAppService.openSystemSettingsLoginItems()
            }
        } catch { show("No se pudo activar el inicio automático", error.localizedDescription) }
        refresh()
    }

    @objc func toggleLogin() {
        if SMAppService.mainApp.status == .enabled {
            do { try SMAppService.mainApp.unregister() }
            catch { show("No se pudo desactivar el inicio automático", error.localizedDescription) }
            refresh()
        } else { enableLogin() }
    }

    func show(_ title: String, _ message: String) {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "Aceptar")
        alert.runModal()
    }

    @objc func quitApp() { NSApp.terminate(nil) }
}

MainActor.assumeIsolated {
    let app = NSApplication.shared
    app.setActivationPolicy(.accessory)
    let delegate = AppDelegate()
    app.delegate = delegate
    withExtendedLifetime(delegate) { app.run() }
}
