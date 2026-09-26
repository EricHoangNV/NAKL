import CoreGraphics

enum SyntheticEventEmitter {

    static let magicFlag = CGEventFlags(rawValue: 1 << 29)

    static func emit(proxy: CGEventTapProxy, buffer: [UInt16], backspaceCount: Int, outputLength: Int) {
        for i in 0..<(backspaceCount + outputLength) {
            guard let down = CGEvent(keyboardEventSource: nil, virtualKey: 1, keyDown: true),
                  let up = CGEvent(keyboardEventSource: nil, virtualKey: 1, keyDown: false) else {
                continue
            }

            down.flags.insert(Self.magicFlag)
            up.flags.insert(Self.magicFlag)

            if buffer[i] == 0x08 {
                down.setIntegerValueField(.keyboardEventKeycode, value: Int64(KeyCode.backSpace))
                up.setIntegerValueField(.keyboardEventKeycode, value: Int64(KeyCode.backSpace))
            } else {
                var c = buffer[i]
                down.keyboardSetUnicodeString(stringLength: 1, unicodeString: &c)
                up.keyboardSetUnicodeString(stringLength: 1, unicodeString: &c)
            }

            down.tapPostEvent(proxy)
            up.tapPostEvent(proxy)
        }
    }
}
