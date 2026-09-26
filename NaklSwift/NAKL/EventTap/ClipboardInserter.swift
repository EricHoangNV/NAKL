import Cocoa
import CoreGraphics

enum ClipboardInserter {

    static func insert(text: String, proxy: CGEventTapProxy, backspaceCount: Int) {
        let pasteboard = NSPasteboard.general

        let savedTypes = pasteboard.types ?? []
        var savedData: [(NSPasteboard.PasteboardType, Data)] = []
        for type in savedTypes {
            if let data = pasteboard.data(forType: type) {
                savedData.append((type, data))
            }
        }

        for _ in 0..<backspaceCount {
            guard let down = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(KeyCode.backSpace), keyDown: true),
                  let up = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(KeyCode.backSpace), keyDown: false) else {
                continue
            }
            down.flags.insert(SyntheticEventEmitter.magicFlag)
            up.flags.insert(SyntheticEventEmitter.magicFlag)
            down.tapPostEvent(proxy)
            up.tapPostEvent(proxy)
        }

        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)

        guard let vDown = CGEvent(keyboardEventSource: nil, virtualKey: 0x09, keyDown: true),
              let vUp = CGEvent(keyboardEventSource: nil, virtualKey: 0x09, keyDown: false) else {
            return
        }
        vDown.flags = [.maskCommand, SyntheticEventEmitter.magicFlag]
        vUp.flags = [.maskCommand, SyntheticEventEmitter.magicFlag]
        vDown.tapPostEvent(proxy)
        vUp.tapPostEvent(proxy)

        let changeCountBefore = pasteboard.changeCount
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            if pasteboard.changeCount == changeCountBefore {
                pasteboard.clearContents()
                for (type, data) in savedData {
                    pasteboard.setData(data, forType: type)
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    pasteboard.clearContents()
                    for (type, data) in savedData {
                        pasteboard.setData(data, forType: type)
                    }
                }
            }
        }
    }
}
