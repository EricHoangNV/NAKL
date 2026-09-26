import SwiftUI
import ServiceManagement
import Observation

@Observable
final class AppState {

    var currentMethod: InputMethod {
        didSet { UserDefaults.standard.set(currentMethod.rawValue, forKey: "NAKLKeyboardMethod") }
    }

    var activeMethod: InputMethod

    var toggleCombo: KeyCombo {
        didSet { saveCombo(toggleCombo, forKey: "NAKLToggleHotKey") }
    }

    var switchMethodCombo: KeyCombo {
        didSet { saveCombo(switchMethodCombo, forKey: "NAKLSwitchMethodHotKey") }
    }

    var excludedApps: [String: String] {
        didSet { UserDefaults.standard.set(excludedApps, forKey: "NAKLExcludedAppBundleIds") }
    }

    var clipboardModeEnabled: Bool {
        didSet { UserDefaults.standard.set(clipboardModeEnabled, forKey: "NAKLClipboardMode") }
    }

    var clipboardModeApps: Set<String> {
        didSet {
            UserDefaults.standard.set(Array(clipboardModeApps), forKey: "NAKLClipboardModeApps")
        }
    }

    var launchAtLogin: Bool = false {
        didSet { updateLoginItem() }
    }

    var shortcuts: [[String: String]] {
        didSet { UserDefaults.standard.set(shortcuts, forKey: "NAKLShortcuts") }
    }

    init() {
        let method = UserDefaults.standard.integer(forKey: "NAKLKeyboardMethod")
        let m = InputMethod(rawValue: method) ?? .telex
        self.currentMethod = m
        self.activeMethod = m

        self.toggleCombo = Self.loadCombo(forKey: "NAKLToggleHotKey")
        self.switchMethodCombo = Self.loadCombo(forKey: "NAKLSwitchMethodHotKey")
        self.excludedApps = UserDefaults.standard.dictionary(forKey: "NAKLExcludedAppBundleIds") as? [String: String] ?? [:]
        self.clipboardModeEnabled = UserDefaults.standard.bool(forKey: "NAKLClipboardMode")
        self.clipboardModeApps = Set(UserDefaults.standard.stringArray(forKey: "NAKLClipboardModeApps") ?? [])
        self.shortcuts = UserDefaults.standard.array(forKey: "NAKLShortcuts") as? [[String: String]] ?? []

        self.launchAtLogin = SMAppService.mainApp.status == .enabled
    }

    private func updateLoginItem() {
        do {
            if launchAtLogin {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            // Silently handle — user will see the toggle not stick
        }
    }

    private func saveCombo(_ combo: KeyCombo, forKey key: String) {
        if let data = try? JSONEncoder().encode(combo) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private static func loadCombo(forKey key: String) -> KeyCombo {
        guard let data = UserDefaults.standard.data(forKey: key),
              let combo = try? JSONDecoder().decode(KeyCombo.self, from: data) else {
            return .empty
        }
        return combo
    }
}
