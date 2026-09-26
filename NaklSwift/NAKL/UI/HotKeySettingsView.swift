import SwiftUI
import Carbon.HIToolbox

struct HotKeySettingsView: View {

    @Bindable var appState: AppState

    var body: some View {
        Form {
            Section("Toggle Vietnamese Input") {
                HotKeyRecorderRow(
                    combo: $appState.toggleCombo,
                    label: "Toggle On/Off"
                )
                Text("Switches Vietnamese input on or off.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Switch Input Method") {
                HotKeyRecorderRow(
                    combo: $appState.switchMethodCombo,
                    label: "Switch VNI ↔ Telex"
                )
                Text("Switches between VNI and Telex when Vietnamese input is active.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

struct HotKeyRecorderRow: View {

    @Binding var combo: KeyCombo
    @State private var isRecording = false

    let label: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Button(action: {
                if isRecording {
                    isRecording = false
                } else {
                    isRecording = true
                }
            }) {
                Text(isRecording ? "Press keys..." : displayString)
                    .frame(minWidth: 120)
            }
            .buttonStyle(.bordered)

            if combo.keyCode != 0 {
                Button("Clear") {
                    combo = .empty
                    isRecording = false
                }
                .buttonStyle(.borderless)
            }
        }
        .background(isRecording ? HotKeyRecorderHelper(combo: $combo, isRecording: $isRecording) : nil)
    }

    private var displayString: String {
        guard combo.keyCode != 0 else { return "Click to record" }
        var parts: [String] = []
        let flags = combo.modifierFlags
        if flags & CGEventFlags.maskControl.rawValue != 0 { parts.append("⌃") }
        if flags & CGEventFlags.maskAlternate.rawValue != 0 { parts.append("⌥") }
        if flags & CGEventFlags.maskShift.rawValue != 0 { parts.append("⇧") }
        if flags & CGEventFlags.maskCommand.rawValue != 0 { parts.append("⌘") }
        parts.append(keyName(combo.keyCode))
        return parts.joined()
    }

    private func keyName(_ keyCode: UInt16) -> String {
        switch Int(keyCode) {
        case kVK_Space: return "Space"
        case kVK_Return: return "Return"
        case kVK_Tab: return "Tab"
        case kVK_Escape: return "Esc"
        case kVK_Delete: return "Delete"
        case kVK_ANSI_A: return "A"
        case kVK_ANSI_S: return "S"
        case kVK_ANSI_D: return "D"
        case kVK_ANSI_F: return "F"
        case kVK_ANSI_G: return "G"
        case kVK_ANSI_H: return "H"
        case kVK_ANSI_J: return "J"
        case kVK_ANSI_K: return "K"
        case kVK_ANSI_L: return "L"
        case kVK_ANSI_Q: return "Q"
        case kVK_ANSI_W: return "W"
        case kVK_ANSI_E: return "E"
        case kVK_ANSI_R: return "R"
        case kVK_ANSI_T: return "T"
        case kVK_ANSI_Y: return "Y"
        case kVK_ANSI_U: return "U"
        case kVK_ANSI_I: return "I"
        case kVK_ANSI_O: return "O"
        case kVK_ANSI_P: return "P"
        case kVK_ANSI_Z: return "Z"
        case kVK_ANSI_X: return "X"
        case kVK_ANSI_C: return "C"
        case kVK_ANSI_V: return "V"
        case kVK_ANSI_B: return "B"
        case kVK_ANSI_N: return "N"
        case kVK_ANSI_M: return "M"
        case kVK_ANSI_1: return "1"
        case kVK_ANSI_2: return "2"
        case kVK_ANSI_3: return "3"
        case kVK_ANSI_4: return "4"
        case kVK_ANSI_5: return "5"
        case kVK_ANSI_6: return "6"
        case kVK_ANSI_7: return "7"
        case kVK_ANSI_8: return "8"
        case kVK_ANSI_9: return "9"
        case kVK_ANSI_0: return "0"
        case kVK_F1: return "F1"
        case kVK_F2: return "F2"
        case kVK_F3: return "F3"
        case kVK_F4: return "F4"
        case kVK_F5: return "F5"
        case kVK_F6: return "F6"
        case kVK_F7: return "F7"
        case kVK_F8: return "F8"
        case kVK_F9: return "F9"
        case kVK_F10: return "F10"
        case kVK_F11: return "F11"
        case kVK_F12: return "F12"
        default: return "Key\(keyCode)"
        }
    }
}

struct HotKeyRecorderHelper: NSViewRepresentable {

    @Binding var combo: KeyCombo
    @Binding var isRecording: Bool

    func makeNSView(context: Context) -> HotKeyRecorderNSView {
        let view = HotKeyRecorderNSView()
        view.onKeyCapture = { keyCode, flags in
            combo = KeyCombo(keyCode: keyCode, modifierFlags: flags)
            isRecording = false
        }
        return view
    }

    func updateNSView(_ nsView: HotKeyRecorderNSView, context: Context) {
        if isRecording {
            DispatchQueue.main.async {
                nsView.window?.makeFirstResponder(nsView)
            }
        }
    }
}

final class HotKeyRecorderNSView: NSView {

    var onKeyCapture: ((UInt16, UInt64) -> Void)?

    override var acceptsFirstResponder: Bool { true }

    override func keyDown(with event: NSEvent) {
        let modifierMask: UInt64 =
            CGEventFlags.maskCommand.rawValue |
            CGEventFlags.maskAlternate.rawValue |
            CGEventFlags.maskControl.rawValue |
            CGEventFlags.maskShift.rawValue

        let flags = UInt64(event.modifierFlags.rawValue) & modifierMask
        if flags != 0 {
            onKeyCapture?(event.keyCode, flags)
        }
    }
}
