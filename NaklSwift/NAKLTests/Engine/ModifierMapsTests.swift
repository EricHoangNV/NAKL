import XCTest
@testable import NAKL

final class ModifierMapsTests: XCTestCase {

    // MARK: - Modifier key strings

    func testVNIModifierKeysLength() {
        XCTAssertEqual(ModifierMaps.vniModifierKeys.count, 10, "VNI has 10 modifier keys: 1-9 plus 0 for tone removal")
    }

    func testVNIModifierKeysContent() {
        XCTAssertEqual(ModifierMaps.vniModifierKeys, "1234567890")
    }

    func testTelexModifierKeysLength() {
        XCTAssertEqual(ModifierMaps.telexModifierKeys.count, 11, "Telex has 11 modifier keys: sfrxjaeowd plus z for tone removal")
    }

    func testTelexModifierKeysContent() {
        XCTAssertEqual(ModifierMaps.telexModifierKeys, "sfrxjaeowdz")
    }

    // MARK: - Modified characters

    func testModifiedCharsCount() {
        XCTAssertEqual(ModifierMaps.modifiedChars.count, 7, "7 modifiable chars: a, e, i, o, u, y, d")
    }

    func testModifiedCharsValues() {
        XCTAssertEqual(ModifierMaps.modifiedChars[0], 0x61) // a
        XCTAssertEqual(ModifierMaps.modifiedChars[1], 0x65) // e
        XCTAssertEqual(ModifierMaps.modifiedChars[2], 0x69) // i
        XCTAssertEqual(ModifierMaps.modifiedChars[3], 0x6F) // o
        XCTAssertEqual(ModifierMaps.modifiedChars[4], 0x75) // u
        XCTAssertEqual(ModifierMaps.modifiedChars[5], 0x79) // y
        XCTAssertEqual(ModifierMaps.modifiedChars[6], 0x64) // d
    }

    // MARK: - Modes dispatch table

    func testModesCount() {
        XCTAssertEqual(ModifierMaps.modes.count, 2, "Two modes: VNI and Telex")
    }

    func testModesIndexZeroIsVNI() {
        // modes[0] == vni (InputMethod.vni.rawValue - 1 == 0)
        XCTAssertEqual(ModifierMaps.modes[0].count, ModifierMaps.vni.count)
    }

    func testModesIndexOneIsTelex() {
        // modes[1] == telex (InputMethod.telex.rawValue - 1 == 1)
        XCTAssertEqual(ModifierMaps.modes[1].count, ModifierMaps.telex.count)
    }

    // MARK: - Separators

    func testSeparatorsCount() {
        XCTAssertEqual(ModifierMaps.separators.count, 3, "3 separators: off, VNI, Telex")
    }

    func testSeparatorOffIsEmpty() {
        XCTAssertEqual(ModifierMaps.separators[0], "")
    }

    func testSeparatorVNIIsNonEmpty() {
        XCTAssertFalse(ModifierMaps.separators[1].isEmpty)
    }

    func testSeparatorTelexIsNonEmpty() {
        XCTAssertFalse(ModifierMaps.separators[2].isEmpty)
    }

    // MARK: - VNI modifier array

    func testVNIModifierArrayCount() {
        XCTAssertEqual(ModifierMaps.vni.count, 11, "VNI has 11 modifier entries")
    }

    func testVNIModifierKeysAreDigitsAndUnderscore() {
        let expectedModifiers: [UInt16] = [
            0x36, 0x37, 0x38, 0x39, 0x5F, // '6','7','8','9','_'
            0x31, 0x32, 0x33, 0x34, 0x35, 0x30, // '1','2','3','4','5','0'
        ]
        for (i, expected) in expectedModifiers.enumerated() {
            XCTAssertEqual(
                ModifierMaps.vni[i].modifier, expected,
                "VNI modifier at index \(i) should be 0x\(String(expected, radix: 16))"
            )
        }
    }

    // MARK: - Telex modifier array

    func testTelexModifierArrayCount() {
        XCTAssertEqual(ModifierMaps.telex.count, 23, "Telex has 23 modifier entries")
    }

    func testTelexIncludesBothCases() {
        let modifiers = ModifierMaps.telex.map { $0.modifier }
        // Check that both 'A' and 'a' are present
        XCTAssertTrue(modifiers.contains(0x41), "Telex should contain 'A' modifier")
        XCTAssertTrue(modifiers.contains(0x61), "Telex should contain 'a' modifier")
        // Check 'S' and 's'
        XCTAssertTrue(modifiers.contains(0x53), "Telex should contain 'S' modifier")
        XCTAssertTrue(modifiers.contains(0x73), "Telex should contain 's' modifier")
        // Check 'D' and 'd'
        XCTAssertTrue(modifiers.contains(0x44), "Telex should contain 'D' modifier")
        XCTAssertTrue(modifiers.contains(0x64), "Telex should contain 'd' modifier")
    }

    // MARK: - Modifiers map bitmasks

    func testVNIModifiersMapCount() {
        XCTAssertEqual(ModifierMaps.vniModifiersMap.count, 7, "One bitmask per modifiable char")
    }

    func testTelexModifiersMapCount() {
        XCTAssertEqual(ModifierMaps.telexModifiersMap.count, 7, "One bitmask per modifiable char")
    }

    // MARK: - Lookup helper methods

    func testModifierKeysForVNI() {
        XCTAssertEqual(ModifierMaps.modifierKeys(for: .vni), "1234567890")
    }

    func testModifierKeysForTelex() {
        XCTAssertEqual(ModifierMaps.modifierKeys(for: .telex), "sfrxjaeowdz")
    }

    func testModifierKeysForOff() {
        XCTAssertEqual(ModifierMaps.modifierKeys(for: .off), "")
    }

    func testModifiersMapForVNI() {
        XCTAssertEqual(ModifierMaps.modifiersMap(for: .vni), ModifierMaps.vniModifiersMap)
    }

    func testModifiersMapForTelex() {
        XCTAssertEqual(ModifierMaps.modifiersMap(for: .telex), ModifierMaps.telexModifiersMap)
    }

    func testModifiersMapForOff() {
        XCTAssertTrue(ModifierMaps.modifiersMap(for: .off).isEmpty)
    }

    // MARK: - VietCode struct

    func testVietCodeDefaultR2IsZero() {
        let code = VietCode(Viet.a, Viet.a1)
        XCTAssertEqual(code.c, Viet.a)
        XCTAssertEqual(code.r1, Viet.a1)
        XCTAssertEqual(code.r2, 0)
    }

    func testVietCodeWithR2() {
        let code = VietCode(Viet.a6, Viet.a, Viet.A)
        XCTAssertEqual(code.c, Viet.a6)
        XCTAssertEqual(code.r1, Viet.a)
        XCTAssertEqual(code.r2, Viet.A)
    }

    // MARK: - InputMethod enum

    func testInputMethodRawValues() {
        XCTAssertEqual(InputMethod.off.rawValue, 0)
        XCTAssertEqual(InputMethod.vni.rawValue, 1)
        XCTAssertEqual(InputMethod.telex.rawValue, 2)
    }

    func testInputMethodCaseCount() {
        XCTAssertEqual(InputMethod.allCases.count, 3)
    }
}
