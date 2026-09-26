import SwiftUI

struct MenuBarView: View {

    @Bindable var appState: AppState
    let engine: VietnameseEngine

    @Environment(\.openSettings) private var openSettings

    var body: some View {
        Group {
            // A Toggle inside a menu-style MenuBarExtra renders as a native
            // NSMenuItem with a checkmark. Composing the check by hand with an
            // HStack/Image is not reliable: newer AppKit menus only honour the
            // first Text/Image of the label and drop the trailing checkmark.
            ForEach(InputMethod.allCases, id: \.self) { method in
                Toggle(label(for: method), isOn: Binding(
                    get: { appState.activeMethod == method },
                    set: { isOn in
                        guard isOn else { return }
                        select(method)
                    }
                ))
            }

            Divider()

            // SettingsLink does nothing when a background (LSUIElement) app is
            // not the active application, which is the normal state for a menu
            // bar utility. Activate first, then open the Settings scene.
            Button("Preferences...") {
                NSApp.activate()
                openSettings()
            }
            .keyboardShortcut(",")

            Divider()

            Button("Quit NAKL 2.0") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
    }

    private func select(_ method: InputMethod) {
        appState.activeMethod = method
        engine.inputMethod = method
        if method != .off {
            appState.currentMethod = method
        }
    }

    private func label(for method: InputMethod) -> String {
        switch method {
        case .off: "Off"
        case .vni: "VNI"
        case .telex: "Telex"
        }
    }
}
