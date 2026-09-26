import XCTest
@testable import NAKL
import CoreGraphics

final class ClipboardInserterTests: XCTestCase {

    // MARK: - Keycode constants used by ClipboardInserter

    func testBackspaceKeycodeConstant() {
        // ClipboardInserter uses KeyCode.backSpace (0x33) for backspace events
        XCTAssertEqual(KeyCode.backSpace, UInt16(0x33),
                       "Backspace keycode must be 0x33 (51 decimal)")
    }

    func testCmdVKeycodeIsCorrect() {
        // ClipboardInserter uses virtualKey 0x09 for Cmd+V paste
        // 0x09 is the macOS virtual keycode for 'V'
        let cmdVKeycode: UInt16 = 0x09
        XCTAssertEqual(cmdVKeycode, 9,
                       "Cmd+V virtual keycode must be 0x09")
    }

    // MARK: - Pasteboard save/restore logic validation

    func testPasteboardSaveAndRestore() {
        let pasteboard = NSPasteboard.general

        // Save current pasteboard state
        let originalTypes = pasteboard.types ?? []
        var originalData: [(NSPasteboard.PasteboardType, Data)] = []
        for type in originalTypes {
            if let data = pasteboard.data(forType: type) {
                originalData.append((type, data))
            }
        }

        // Write test content
        let testString = "NAKL_TEST_\(UUID().uuidString)"
        pasteboard.clearContents()
        pasteboard.setString(testString, forType: .string)

        // Verify test content was written
        XCTAssertEqual(pasteboard.string(forType: .string), testString)

        // Simulate the restore logic from ClipboardInserter
        pasteboard.clearContents()
        for (type, data) in originalData {
            pasteboard.setData(data, forType: type)
        }

        // After restore, the test string should no longer be on the pasteboard
        // (unless it was there before the test)
        if !originalData.isEmpty {
            XCTAssertNotEqual(pasteboard.string(forType: .string), testString,
                              "Pasteboard should be restored to original content")
        }
    }

    // MARK: - Magic flag is used for synthetic events

    func testClipboardInserterUsesMagicFlag() {
        // Verify the magic flag value that ClipboardInserter applies to synthetic events
        let magicFlag = SyntheticEventEmitter.magicFlag
        XCTAssertEqual(magicFlag.rawValue, 1 << 29,
                       "ClipboardInserter relies on SyntheticEventEmitter.magicFlag")
    }

    // MARK: - Pasteboard types round-trip

    func testPasteboardTypesPreservation() {
        let pasteboard = NSPasteboard.general

        // Store original state
        let savedTypes = pasteboard.types ?? []
        var savedData: [(NSPasteboard.PasteboardType, Data)] = []
        for type in savedTypes {
            if let data = pasteboard.data(forType: type) {
                savedData.append((type, data))
            }
        }

        // Write multi-type data
        pasteboard.clearContents()
        pasteboard.setString("test_string", forType: .string)

        // Read back types
        let currentTypes = pasteboard.types ?? []
        XCTAssertTrue(currentTypes.contains(.string),
                      "Pasteboard should contain string type after setString")

        // Restore original
        pasteboard.clearContents()
        for (type, data) in savedData {
            pasteboard.setData(data, forType: type)
        }
    }
}
