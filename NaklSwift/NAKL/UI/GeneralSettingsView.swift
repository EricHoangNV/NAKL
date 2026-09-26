import SwiftUI

struct GeneralSettingsView: View {

    @Bindable var appState: AppState

    var body: some View {
        Form {
            Section("Input Method") {
                Picker("Default method", selection: $appState.currentMethod) {
                    Text("VNI").tag(InputMethod.vni)
                    Text("Telex").tag(InputMethod.telex)
                }
                .pickerStyle(.segmented)
            }

            Section("Startup") {
                Toggle("Launch NAKL at login", isOn: $appState.launchAtLogin)
            }

            Section("Text Insertion") {
                Toggle("Use clipboard mode (for Electron apps)", isOn: $appState.clipboardModeEnabled)
                Text("When enabled, text is inserted via clipboard paste instead of synthetic key events. Better compatibility with VS Code, Slack, etc.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}
