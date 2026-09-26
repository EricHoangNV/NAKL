import SwiftUI

struct ShortcutsSettingsView: View {

    @Bindable var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Text Shortcuts")
                .font(.headline)
            Text("Type the shortcut followed by Space to expand.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Table(of: IndexedShortcut.self) {
                TableColumn("Shortcut") { item in
                    TextField("Shortcut", text: Binding(
                        get: { item.shortcut["shortcut"] ?? "" },
                        set: { newValue in
                            appState.shortcuts[item.index]["shortcut"] = newValue
                        }
                    ))
                }
                TableColumn("Expansion") { item in
                    TextField("Expansion", text: Binding(
                        get: { item.shortcut["text"] ?? "" },
                        set: { newValue in
                            appState.shortcuts[item.index]["text"] = newValue
                        }
                    ))
                }
            } rows: {
                ForEach(Array(appState.shortcuts.enumerated()), id: \.offset) { index, shortcut in
                    TableRow(IndexedShortcut(index: index, shortcut: shortcut))
                }
            }

            HStack {
                Button("Add") {
                    appState.shortcuts.append(["shortcut": "", "text": ""])
                }
                Button("Remove Last") {
                    if !appState.shortcuts.isEmpty {
                        appState.shortcuts.removeLast()
                    }
                }
                .disabled(appState.shortcuts.isEmpty)
            }
        }
        .padding()
    }
}

private struct IndexedShortcut: Identifiable {
    let index: Int
    let shortcut: [String: String]
    var id: Int { index }
}
