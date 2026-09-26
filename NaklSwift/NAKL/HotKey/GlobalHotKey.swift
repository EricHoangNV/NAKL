import Foundation

struct KeyCombo: Codable, Equatable {
    var keyCode: UInt16
    var modifierFlags: UInt64

    static let empty = KeyCombo(keyCode: 0, modifierFlags: 0)

    func matches(flags: UInt64, keycode: UInt16) -> Bool {
        guard keyCode != 0 else { return false }
        return flags == modifierFlags && keycode == keyCode
    }
}
