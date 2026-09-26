import XCTest
@testable import NAKL
import CoreGraphics

final class SyntheticEventEmitterTests: XCTestCase {

    // MARK: - Magic flag value

    func testMagicFlagRawValue() {
        XCTAssertEqual(SyntheticEventEmitter.magicFlag.rawValue, 1 << 29,
                       "magicFlag must equal 1 << 29 (0x20000000)")
    }

    func testMagicFlagIsExactlyOneBit() {
        let raw = SyntheticEventEmitter.magicFlag.rawValue
        // A single-bit value satisfies: raw & (raw - 1) == 0 and raw != 0
        XCTAssertNotEqual(raw, 0)
        XCTAssertEqual(raw & (raw - 1), 0,
                       "Magic flag should be a single bit")
    }

    func testMagicFlagHexValue() {
        XCTAssertEqual(SyntheticEventEmitter.magicFlag.rawValue, 0x20000000,
                       "1 << 29 should equal 0x20000000")
    }

    func testMagicFlagIsCGEventFlagsType() {
        let flag: CGEventFlags = SyntheticEventEmitter.magicFlag
        // This compiles only if magicFlag is CGEventFlags
        XCTAssertEqual(flag, CGEventFlags(rawValue: 1 << 29))
    }

    // MARK: - Backspace code constant

    func testBackspaceKeyCode() {
        XCTAssertEqual(KeyCode.backSpace, 0x33,
                       "Backspace virtual keycode on macOS must be 0x33")
    }
}
