import Foundation

enum KeyCode {
    static let spaceBar:   UniChar = 0x0020
    static let backSpace:  UInt16 = 0x33
    static let returnKey:  UInt16 = 0x24
    static let returnNum:  UInt16 = 0x4C
    static let home:       UInt16 = 0x73
    static let left:       UInt16 = 0x7B
    static let up:         UInt16 = 0x7E
    static let right:      UInt16 = 0x7C
    static let down:       UInt16 = 0x7D
    static let end:        UInt16 = 0x77
    static let tab:        UInt16 = 0x30
    static let delete:     UInt16 = 0x75
    static let pageUp:     UInt16 = 0x74
    static let pageDown:   UInt16 = 0x79

    static let navigationKeys: Set<UInt16> = [
        returnKey, returnNum, home, left, up, right, down,
        end, tab, backSpace, delete, pageUp, pageDown,
    ]
}
