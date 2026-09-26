import SwiftUI

@main
struct NAKLApp: App {

    @State private var appState = AppState()
    @State private var engine = VietnameseEngine()
    @State private var eventTapManager: EventTapManager?

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(appState: appState, engine: engine)
        } label: {
            Image(systemName: appState.activeMethod == .off ? "character.cursor.ibeam" : "character.textbox")
        }

        Settings {
            PreferencesView(appState: appState)
        }
    }

    init() {
        print("[NAKL] App init starting")
        let state = AppState()
        let eng = VietnameseEngine()
        eng.inputMethod = state.currentMethod
        _appState = State(initialValue: state)
        _engine = State(initialValue: eng)

        let granted = AccessibilityPermission.requestIfNeeded()
        print("[NAKL] Accessibility trusted: \(granted)")
        print("[NAKL] Bundle identifier: \(Bundle.main.bundleIdentifier ?? "nil")")

        let manager = EventTapManager(engine: eng, appState: state)
        _eventTapManager = State(initialValue: manager)
        manager.start()
    }
}
