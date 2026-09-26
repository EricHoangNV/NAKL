import SwiftUI

struct ExcludedAppsSettingsView: View {

    @Bindable var appState: AppState
    @State private var showAppPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Vietnamese input is disabled for these apps:")
                .font(.headline)

            List {
                ForEach(Array(appState.excludedApps.keys.sorted()), id: \.self) { bundleId in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(appState.excludedApps[bundleId] ?? bundleId)
                                .font(.body)
                            Text(bundleId)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()

                        if appState.clipboardModeApps.contains(bundleId) {
                            Text("Clipboard")
                                .font(.caption)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.blue.opacity(0.2))
                                .clipShape(Capsule())
                        }
                    }
                }
                .onDelete { indices in
                    let keys = appState.excludedApps.keys.sorted()
                    for index in indices {
                        let key = keys[index]
                        appState.excludedApps.removeValue(forKey: key)
                        appState.clipboardModeApps.remove(key)
                    }
                }
            }

            HStack {
                Button("Add from Running Apps...") {
                    showAppPicker = true
                }

                Button("Remove Selected") {
                    // Selection handled by onDelete
                }
                .disabled(appState.excludedApps.isEmpty)
            }
        }
        .padding()
        .sheet(isPresented: $showAppPicker) {
            RunningAppsPickerView(appState: appState, isPresented: $showAppPicker)
        }
    }
}

struct RunningAppsPickerView: View {

    @Bindable var appState: AppState
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("Select an app to exclude")
                .font(.headline)

            List(NSWorkspace.shared.runningApplications.filter { $0.activationPolicy == .regular },
                 id: \.bundleIdentifier) { app in
                Button {
                    if let bundleId = app.bundleIdentifier {
                        appState.excludedApps[bundleId] = app.localizedName ?? bundleId
                    }
                    isPresented = false
                } label: {
                    HStack {
                        if let icon = app.icon {
                            Image(nsImage: icon)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        Text(app.localizedName ?? "Unknown")
                        Spacer()
                        Text(app.bundleIdentifier ?? "")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
            }

            Button("Cancel") {
                isPresented = false
            }
            .padding()
        }
        .frame(width: 400, height: 300)
    }
}
