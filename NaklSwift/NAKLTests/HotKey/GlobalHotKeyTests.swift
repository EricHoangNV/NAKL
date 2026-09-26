import XCTest
@testable import NAKL
import CoreGraphics

final class GlobalHotKeyTests: XCTestCase {

    // MARK: - KeyCombo.empty

    func testEmptyKeyComboHasZeroKeyCode() {
        XCTAssertEqual(KeyCombo.empty.keyCode, 0)
    }

    func testEmptyKeyComboHasZeroModifierFlags() {
        XCTAssertEqual(KeyCombo.empty.modifierFlags, 0)
    }

    // MARK: - KeyCombo.matches

    func testEmptyComboNeverMatches() {
        let combo = KeyCombo.empty
        XCTAssertFalse(combo.matches(flags: 0, keycode: 0),
                       "Empty combo (keyCode == 0) must always return false")
    }

    func testEmptyComboDoesNotMatchArbitraryInput() {
        let combo = KeyCombo.empty
        XCTAssertFalse(combo.matches(
            flags: CGEventFlags.maskCommand.rawValue,
            keycode: 0x09
        ))
    }

    func testMatchesWithCorrectFlagsAndKeycode() {
        let combo = KeyCombo(
            keyCode: 0x09, // 'V' key
            modifierFlags: CGEventFlags.maskCommand.rawValue
        )
        XCTAssertTrue(combo.matches(
            flags: CGEventFlags.maskCommand.rawValue,
            keycode: 0x09
        ))
    }

    func testMismatchedFlagsReturnsFalse() {
        let combo = KeyCombo(
            keyCode: 0x09,
            modifierFlags: CGEventFlags.maskCommand.rawValue
        )
        XCTAssertFalse(combo.matches(
            flags: CGEventFlags.maskAlternate.rawValue,
            keycode: 0x09
        ), "Different modifier flags should not match")
    }

    func testMismatchedKeycodeReturnsFalse() {
        let combo = KeyCombo(
            keyCode: 0x09,
            modifierFlags: CGEventFlags.maskCommand.rawValue
        )
        XCTAssertFalse(combo.matches(
            flags: CGEventFlags.maskCommand.rawValue,
            keycode: 0x0A
        ), "Different keycode should not match")
    }

    func testMatchesWithMultipleModifiers() {
        let flags = CGEventFlags.maskCommand.rawValue | CGEventFlags.maskShift.rawValue
        let combo = KeyCombo(keyCode: 0x31, modifierFlags: flags)
        XCTAssertTrue(combo.matches(flags: flags, keycode: 0x31))
    }

    func testPartialModifierFlagsDoNotMatch() {
        let fullFlags = CGEventFlags.maskCommand.rawValue | CGEventFlags.maskShift.rawValue
        let partialFlags = CGEventFlags.maskCommand.rawValue
        let combo = KeyCombo(keyCode: 0x00, modifierFlags: fullFlags)
        XCTAssertFalse(combo.matches(flags: partialFlags, keycode: 0x00),
                       "Partial modifier flags must not match")
    }

    // MARK: - Codable round-trip

    func testCodableRoundTrip() throws {
        let original = KeyCombo(
            keyCode: 0x31,
            modifierFlags: CGEventFlags.maskControl.rawValue | CGEventFlags.maskAlternate.rawValue
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(KeyCombo.self, from: data)

        XCTAssertEqual(decoded.keyCode, original.keyCode)
        XCTAssertEqual(decoded.modifierFlags, original.modifierFlags)
    }

    func testCodableRoundTripEmpty() throws {
        let original = KeyCombo.empty

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(KeyCombo.self, from: data)

        XCTAssertEqual(decoded, original)
    }

    func testCodableRoundTripWithLargeFlags() throws {
        let original = KeyCombo(
            keyCode: 0xFF,
            modifierFlags: 0xFFFFFFFF
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(KeyCombo.self, from: data)

        XCTAssertEqual(decoded, original)
    }

    // MARK: - Equatable

    func testEqualCombos() {
        let a = KeyCombo(keyCode: 42, modifierFlags: 100)
        let b = KeyCombo(keyCode: 42, modifierFlags: 100)
        XCTAssertEqual(a, b)
    }

    func testUnequalCombos() {
        let a = KeyCombo(keyCode: 42, modifierFlags: 100)
        let b = KeyCombo(keyCode: 43, modifierFlags: 100)
        XCTAssertNotEqual(a, b)
    }
}
