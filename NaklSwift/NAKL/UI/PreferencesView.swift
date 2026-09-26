import SwiftUI

struct PreferencesView: View {

    @Bindable var appState: AppState

    var body: some View {
        TabView {
            GeneralSettingsView(appState: appState)
                .tabItem { Label("General", systemImage: "gear") }

            HotKeySettingsView(appState: appState)
                .tabItem { Label("Hotkeys", systemImage: "keyboard") }

            ExcludedAppsSettingsView(appState: appState)
                .tabItem { Label("Excluded Apps", systemImage: "xmark.app") }

            ShortcutsSettingsView(appState: appState)
                .tabItem { Label("Shortcuts", systemImage: "text.cursor") }
        }
        .frame(width: 480, height: 360)
    }
}
