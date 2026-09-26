//
//  ModifierMaps.swift
//  NAKL
//
//  Ported from utf.h, AppDelegate.m, and keymap.h
//  Original copyright (C) 2012 by Huy Phan <dachuy@gmail.com>
//  Licensed under the GNU General Public License v3 or later.
//

import Foundation

// MARK: - Modifier struct

struct Modifier {
    let level: Int
    let modifier: UInt16
    let code: [VietCode]
}

// MARK: - Keyboard constants (from keymap.h)

enum KC {
    // XK constants
    static let XK_VoidSymbol:   UInt16 = 0xFF
    static let XK_BackSpace:    UInt16 = 0x08
    static let XK_Tab:          UInt16 = 0x09
    static let XK_Linefeed:     UInt16 = 0x0A
    static let XK_Clear:        UInt16 = 0x0B
    static let XK_Return:       UInt16 = 0x0D
    static let XK_Pause:        UInt16 = 0x13
    static let XK_Scroll_Lock:  UInt16 = 0x14
    static let XK_Sys_Req:      UInt16 = 0x15
    static let XK_Escape:       UInt16 = 0x1B
    static let XK_SpaceBar:     UInt16 = 0x20
    static let XK_Delete:       UInt16 = 0xFF

    // Cursor control & motion
    static let XK_Home:         UInt16 = 0x50
    static let XK_Left:         UInt16 = 0x51
    static let XK_Up:           UInt16 = 0x52
    static let XK_Right:        UInt16 = 0x53
    static let XK_Down:         UInt16 = 0x54
    static let XK_Prior:        UInt16 = 0x55
    static let XK_Page_Up:      UInt16 = 0x55
    static let XK_Next:         UInt16 = 0x56
    static let XK_Page_Down:    UInt16 = 0x56
    static let XK_End:          UInt16 = 0x57
    static let XK_Begin:        UInt16 = 0x58

    // Special Windows keyboard keys
    static let XK_Win_L:        UInt16 = 0x5B
    static let XK_Win_R:        UInt16 = 0x5C
    static let XK_App:          UInt16 = 0x5D

    // Misc Functions
    static let XK_Select:       UInt16 = 0x60
    static let XK_Print:        UInt16 = 0x61
    static let XK_Execute:      UInt16 = 0x62
    static let XK_Insert:       UInt16 = 0x63
    static let XK_Undo:         UInt16 = 0x65
    static let XK_Redo:         UInt16 = 0x66
    static let XK_Menu:         UInt16 = 0x67
    static let XK_Find:         UInt16 = 0x68
    static let XK_Cancel:       UInt16 = 0x69
    static let XK_Help:         UInt16 = 0x6A
    static let XK_Break:        UInt16 = 0x6B
    static let XK_Mode_switch:  UInt16 = 0x7E
    static let XK_script_switch: UInt16 = 0x7E
    static let XK_Num_Lock:     UInt16 = 0x7F

    // Function keys
    static let XK_F1:           UInt16 = 0xBE
    static let XK_F2:           UInt16 = 0xBF
    static let XK_F3:           UInt16 = 0xC0
    static let XK_F4:           UInt16 = 0xC1
    static let XK_F5:           UInt16 = 0xC2
    static let XK_F6:           UInt16 = 0xC3
    static let XK_F7:           UInt16 = 0xC4
    static let XK_F8:           UInt16 = 0xC5
    static let XK_F9:           UInt16 = 0xC6
    static let XK_F10:          UInt16 = 0xC7
    static let XK_F11:          UInt16 = 0xC8
    static let XK_L1:           UInt16 = 0xC8
    static let XK_F12:          UInt16 = 0xC9
    static let XK_L2:           UInt16 = 0xC9
    static let XK_F13:          UInt16 = 0xCA
    static let XK_L3:           UInt16 = 0xCA
    static let XK_F14:          UInt16 = 0xCB
    static let XK_L4:           UInt16 = 0xCB
    static let XK_F15:          UInt16 = 0xCC
    static let XK_L5:           UInt16 = 0xCC
    static let XK_F16:          UInt16 = 0xCD
    static let XK_L6:           UInt16 = 0xCD
    static let XK_F17:          UInt16 = 0xCE
    static let XK_L7:           UInt16 = 0xCE
    static let XK_F18:          UInt16 = 0xCF
    static let XK_L8:           UInt16 = 0xCF
    static let XK_F19:          UInt16 = 0xD0
    static let XK_L9:           UInt16 = 0xD0
    static let XK_F20:          UInt16 = 0xD1
    static let XK_L10:          UInt16 = 0xD1
    static let XK_F21:          UInt16 = 0xD2
    static let XK_R1:           UInt16 = 0xD2
    static let XK_F22:          UInt16 = 0xD3
    static let XK_R2:           UInt16 = 0xD3
    static let XK_F23:          UInt16 = 0xD4
    static let XK_R3:           UInt16 = 0xD4
    static let XK_F24:          UInt16 = 0xD5
    static let XK_R4:           UInt16 = 0xD5
    static let XK_F25:          UInt16 = 0xD6
    static let XK_R5:           UInt16 = 0xD6
    static let XK_F26:          UInt16 = 0xD7
    static let XK_R6:           UInt16 = 0xD7
    static let XK_F27:          UInt16 = 0xD8
    static let XK_R7:           UInt16 = 0xD8
    static let XK_F28:          UInt16 = 0xD9
    static let XK_R8:           UInt16 = 0xD9
    static let XK_F29:          UInt16 = 0xDA
    static let XK_R9:           UInt16 = 0xDA
    static let XK_F30:          UInt16 = 0xDB
    static let XK_R10:          UInt16 = 0xDB
    static let XK_F31:          UInt16 = 0xDC
    static let XK_R11:          UInt16 = 0xDC
    static let XK_F32:          UInt16 = 0xDD
    static let XK_R12:          UInt16 = 0xDD
    static let XK_F33:          UInt16 = 0xDE
    static let XK_R13:          UInt16 = 0xDE
    static let XK_F34:          UInt16 = 0xDF
    static let XK_R14:          UInt16 = 0xDF
    static let XK_F35:          UInt16 = 0xE0
    static let XK_R15:          UInt16 = 0xE0

    // Modifiers
    static let XK_Shift_L:      UInt16 = 0xE1
    static let XK_Shift_R:      UInt16 = 0xE2
    static let XK_Control_L:    UInt16 = 0xE3
    static let XK_Control_R:    UInt16 = 0xE4
    static let XK_Caps_Lock:    UInt16 = 0xE5
    static let XK_Shift_Lock:   UInt16 = 0xE6
    static let XK_Meta_L:       UInt16 = 0xE7
    static let XK_Meta_R:       UInt16 = 0xE8
    static let XK_Alt_L:        UInt16 = 0xE9
    static let XK_Alt_R:        UInt16 = 0xEA
    static let XK_Super_L:      UInt16 = 0xEB
    static let XK_Super_R:      UInt16 = 0xEC
    static let XK_Hyper_L:      UInt16 = 0xED
    static let XK_Hyper_R:      UInt16 = 0xEE

    // Mac keycodes (KC_ prefix in original)
    static let BackSpace:       UInt16 = 0x33
    static let Tab:             UInt16 = 0x30
    static let Return:          UInt16 = 0x24
    static let Return_Num:      UInt16 = 0x4C
    static let Escape:          UInt16 = 0x35
    static let SpaceBar:        UInt16 = 0x31
    static let Delete:          UInt16 = 0x75

    // Cursor control & motion (Mac keycodes)
    static let Home:            UInt16 = 0x73
    static let Left:            UInt16 = 0x7B
    static let Up:              UInt16 = 0x7E
    static let Right:           UInt16 = 0x7C
    static let Down:            UInt16 = 0x7D
    static let Page_Up:         UInt16 = 0x74
    static let Page_Down:       UInt16 = 0x79
    static let End:             UInt16 = 0x77
}

// MARK: - ModifierMaps

enum ModifierMaps {

    // MARK: Characters that can be modified: a, e, i, o, u, y, d

    static let modifiedChars: [UInt16] = [
        0x61, // a
        0x65, // e
        0x69, // i
        0x6F, // o
        0x75, // u
        0x79, // y
        0x64  // d
    ]

    // MARK: Modifier keys per input method

    static let vniModifierKeys: String = "1234567890"
    static let telexModifierKeys: String = "sfrxjaeowdz"

    // MARK: Modifier bitmask arrays
    //       Index order matches modifiedChars: a, e, i, o, u, y, d
    //       Bit positions correspond to characters in modifierKeys string

    static let vniModifiersMap: [UInt16] = [
        703, 575, 543, 639, 607, 543, 256
    ]

    static let telexModifiersMap: [UInt16] = [
        1343, 1119, 1055, 1439, 1311, 1055, 512
    ]

    // MARK: Lookup helpers

    static func modifierKeys(for method: InputMethod) -> String {
        switch method {
        case .vni:   return vniModifierKeys
        case .telex: return telexModifierKeys
        case .off:   return ""
        }
    }

    static func modifiersMap(for method: InputMethod) -> [UInt16] {
        switch method {
        case .vni:   return vniModifiersMap
        case .telex: return telexModifiersMap
        case .off:   return []
        }
    }

    // MARK: - Telex modifier array
    // Ported from modifier_t telex[] in utf.h (lines 356-399)

    static let telex: [Modifier] = [
        Modifier(level: 1, modifier: 0x41, code: TelexRules.code_A),   // 'A'
        Modifier(level: 1, modifier: 0x61, code: TelexRules.code_a),   // 'a'
        Modifier(level: 1, modifier: 0x45, code: TelexRules.code_E),   // 'E'
        Modifier(level: 1, modifier: 0x65, code: TelexRules.code_e),   // 'e'
        Modifier(level: 1, modifier: 0x4F, code: TelexRules.code_O),   // 'O'
        Modifier(level: 1, modifier: 0x6F, code: TelexRules.code_o),   // 'o'
        Modifier(level: 1, modifier: 0x57, code: TelexRules.code_W),   // 'W'
        Modifier(level: 1, modifier: 0x77, code: TelexRules.code_w),   // 'w'
        Modifier(level: 1, modifier: 0x44, code: TelexRules.code_D),   // 'D'
        Modifier(level: 1, modifier: 0x64, code: TelexRules.code_d),   // 'd'
        Modifier(level: 1, modifier: 0x5F, code: SharedRules.code_sign), // '_'
        Modifier(level: 2, modifier: 0x53, code: TelexRules.code_S),   // 'S'
        Modifier(level: 2, modifier: 0x73, code: TelexRules.code_s),   // 's'
        Modifier(level: 2, modifier: 0x46, code: TelexRules.code_F),   // 'F'
        Modifier(level: 2, modifier: 0x66, code: TelexRules.code_f),   // 'f'
        Modifier(level: 2, modifier: 0x52, code: TelexRules.code_R),   // 'R'
        Modifier(level: 2, modifier: 0x72, code: TelexRules.code_r),   // 'r'
        Modifier(level: 2, modifier: 0x58, code: TelexRules.code_X),   // 'X'
        Modifier(level: 2, modifier: 0x78, code: TelexRules.code_x),   // 'x'
        Modifier(level: 2, modifier: 0x4A, code: TelexRules.code_J),   // 'J'
        Modifier(level: 2, modifier: 0x6A, code: TelexRules.code_j),   // 'j'
        Modifier(level: 2, modifier: 0x5A, code: SharedRules.code_z),   // 'Z'
        Modifier(level: 2, modifier: 0x7A, code: SharedRules.code_z),   // 'z'
    ]

    // MARK: - VNI modifier array
    // Ported from modifier_t vni[] in utf.h (lines 1486-1500)

    static let vni: [Modifier] = [
        Modifier(level: 1, modifier: 0x36, code: VNIRules.code_6),     // '6' — circumflex
        Modifier(level: 1, modifier: 0x37, code: VNIRules.code_7),     // '7' — horn
        Modifier(level: 1, modifier: 0x38, code: VNIRules.code_8),     // '8' — breve
        Modifier(level: 1, modifier: 0x39, code: VNIRules.code_9),     // '9' — d-bar
        Modifier(level: 1, modifier: 0x5F, code: SharedRules.code_sign),  // '_' — VND sign
        Modifier(level: 2, modifier: 0x31, code: VNIRules.code_1),     // '1' — acute
        Modifier(level: 2, modifier: 0x32, code: VNIRules.code_2),     // '2' — grave
        Modifier(level: 2, modifier: 0x33, code: VNIRules.code_3),     // '3' — hook above
        Modifier(level: 2, modifier: 0x34, code: VNIRules.code_4),     // '4' — tilde
        Modifier(level: 2, modifier: 0x35, code: VNIRules.code_5),     // '5' — dot below
        Modifier(level: 2, modifier: 0x30, code: SharedRules.code_z),     // '0' — remove tone
    ]

    // MARK: - Modes dispatch table
    // Indexed by (InputMethod.rawValue - 1): [0] = vni, [1] = telex

    static let modes: [[Modifier]] = [
        vni,
        telex,
    ]

    // MARK: - Separators (from AppDelegate.m)
    // Index matches InputMethod raw value: 0 = off, 1 = VNI, 2 = Telex

    static let separators: [String] = [
        "",                                         // VKM_OFF
        "!@#$%&)|\\-{}[]:\";<>,/'`~?.^*(+=",        // VKM_VNI
        "!@#$%&)|\\-:\";<>,/'`~?.^*(+="             // VKM_TELEX
    ]
}
