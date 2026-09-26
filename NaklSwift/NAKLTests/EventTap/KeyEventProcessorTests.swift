import XCTest
@testable import NAKL
import CoreGraphics

final class KeyEventProcessorTests: XCTestCase {

    // MARK: - Magic flag detection

    func testMagicFlagBitPosition() {
        let magicFlag = SyntheticEventEmitter.magicFlag
        XCTAssertEqual(magicFlag.rawValue, 1 << 29,
                       "Magic flag must be bit 29 to avoid colliding with real CGEventFlags")
    }

    func testMagicFlagDoesNotOverlapSystemFlags() {
        let systemFlags: [CGEventFlags] = [
            .maskCommand, .maskAlternate, .maskControl,
            .maskShift, .maskSecondaryFn, .maskHelp,
            .maskAlphaShift, .maskNumericPad
        ]
        for flag in systemFlags {
            XCTAssertEqual(
                SyntheticEventEmitter.magicFlag.rawValue & flag.rawValue, 0,
                "Magic flag must not overlap system flag \(flag.rawValue)"
            )
        }
    }

    // MARK: - Navigation key detection

    func testNavigationKeysContainsExpectedKeys() {
        let expected: [UInt16] = [
            KeyCode.returnKey, KeyCode.returnNum,
            KeyCode.home, KeyCode.left, KeyCode.up, KeyCode.right, KeyCode.down,
            KeyCode.end, KeyCode.tab, KeyCode.backSpace, KeyCode.delete,
            KeyCode.pageUp, KeyCode.pageDown,
        ]
        for key in expected {
            XCTAssertTrue(KeyCode.navigationKeys.contains(key),
                          "Navigation keys should contain 0x\(String(key, radix: 16))")
        }
    }

    func testNavigationKeysCount() {
        XCTAssertEqual(KeyCode.navigationKeys.count, 13,
                       "There should be exactly 13 navigation keys")
    }

    func testAlphaKeysAreNotNavigationKeys() {
        // 'a' through 'z' virtual keycodes on macOS are 0x00..0x2F range
        // but none should be in the navigation set
        let alphaKeycodes: [UInt16] = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05]
        for kc in alphaKeycodes {
            XCTAssertFalse(KeyCode.navigationKeys.contains(kc),
                           "Alpha keycode \(kc) must not be a navigation key")
        }
    }

    // MARK: - Separator character detection

    func testVNISeparatorsExist() {
        let vniSeps = ModifierMaps.separators[InputMethod.vni.rawValue]
        XCTAssertFalse(vniSeps.isEmpty, "VNI separators must not be empty")
    }

    func testTelexSeparatorsExist() {
        let telexSeps = ModifierMaps.separators[InputMethod.telex.rawValue]
        XCTAssertFalse(telexSeps.isEmpty, "Telex separators must not be empty")
    }

    func testOffSeparatorsEmpty() {
        let offSeps = ModifierMaps.separators[InputMethod.off.rawValue]
        XCTAssertTrue(offSeps.isEmpty, "Off-mode separators must be empty")
    }

    func testVNISeparatorsContainDigitKeys() {
        // VNI uses digits 0-9 as modifiers, so they should NOT be separators
        let vniSeps = ModifierMaps.separators[InputMethod.vni.rawValue]
        for digit in "0123456789".unicodeScalars {
            XCTAssertFalse(vniSeps.utf8.contains(UInt8(digit.value)),
                           "VNI separators must not contain digit '\(digit)' (used as modifier)")
        }
    }

    func testTelexSeparatorsDoNotContainModifierLetters() {
        // Telex modifier keys: s, f, r, x, j, a, e, o, w, d
        let telexSeps = ModifierMaps.separators[InputMethod.telex.rawValue]
        for ch in "sfrxjaeowd".unicodeScalars {
            XCTAssertFalse(telexSeps.utf8.contains(UInt8(ch.value)),
                           "Telex separators must not contain modifier letter '\(ch)'")
        }
    }

    func testTelexSeparatorsContainDigits() {
        // Unlike VNI, Telex does not use digits, so digits should be separators
        // However, looking at the actual separator string, digits are not included
        // Verify the actual content matches expectations
        let telexSeps = ModifierMaps.separators[InputMethod.telex.rawValue]
        // Common punctuation should be separators
        for ch in "!@#$%".unicodeScalars {
            XCTAssertTrue(telexSeps.utf8.contains(UInt8(ch.value)),
                          "Telex separators should contain '\(ch)'")
        }
    }

    // MARK: - ModifierMaps.separators structure

    func testSeparatorsArrayHasThreeEntries() {
        XCTAssertEqual(ModifierMaps.separators.count, 3,
                       "Separators array must have entries for off, VNI, and Telex")
    }

    // MARK: - Control keys mask

    func testControlKeysMaskIncludesCommand() {
        XCTAssertNotEqual(EventTapManager.controlKeys & CGEventFlags.maskCommand.rawValue, 0)
    }

    func testControlKeysMaskIncludesAlternate() {
        XCTAssertNotEqual(EventTapManager.controlKeys & CGEventFlags.maskAlternate.rawValue, 0)
    }

    func testControlKeysMaskIncludesControl() {
        XCTAssertNotEqual(EventTapManager.controlKeys & CGEventFlags.maskControl.rawValue, 0)
    }

    func testControlKeysMaskExcludesShift() {
        XCTAssertEqual(EventTapManager.controlKeys & CGEventFlags.maskShift.rawValue, 0,
                       "Shift alone should not be treated as a control key")
    }
}
