import XCTest
@testable import NAKL

final class VNITypingIntegrationTests: XCTestCase {

    private var engine: VietnameseEngine!

    override func setUp() {
        super.setUp()
        engine = VietnameseEngine()
        engine.inputMethod = .vni
    }

    override func tearDown() {
        engine = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func typeAndGetOutput(_ keys: String) -> String {
        var lastOutput = ""
        for char in keys.unicodeScalars {
            let result = engine.addKey(UniChar(char.value))
            if result >= 0 {
                let slice = engine.getOutputSlice()
                let chars = slice.pointer.dropFirst(slice.backspaceCount).prefix(slice.outputLength)
                lastOutput = String(chars.map { Character(UnicodeScalar($0)!) })
            }
        }
        return lastOutput
    }

    private func typeAndGetLastSlice(_ keys: String) -> (backspaces: Int, output: [UInt16]) {
        var lastSlice: (pointer: [UInt16], backspaceCount: Int, outputLength: Int)?
        for char in keys.unicodeScalars {
            let result = engine.addKey(UniChar(char.value))
            if result >= 0 {
                lastSlice = engine.getOutputSlice()
            }
        }
        guard let slice = lastSlice else {
            return (0, [])
        }
        let outputChars = Array(slice.pointer.dropFirst(slice.backspaceCount).prefix(slice.outputLength))
        return (slice.backspaceCount, outputChars)
    }

    // MARK: - Acute tone (1)

    func testVNIA1() {
        // 'a' + '1' in VNI = a with acute = 0x00E1
        let output = typeAndGetOutput("a1")
        XCTAssertEqual(output, "\u{00E1}", "a1 -> a with acute accent")
    }

    // MARK: - Grave tone (2)

    func testVNIA2() {
        let output = typeAndGetOutput("a2")
        XCTAssertEqual(output, "\u{00E0}", "a2 -> a with grave accent")
    }

    // MARK: - Hook above (3)

    func testVNIA3() {
        let output = typeAndGetOutput("a3")
        XCTAssertEqual(output, "\u{1EA3}", "a3 -> a with hook above")
    }

    // MARK: - Tilde (4)

    func testVNIA4() {
        let output = typeAndGetOutput("a4")
        XCTAssertEqual(output, "\u{00E3}", "a4 -> a with tilde")
    }

    // MARK: - Dot below (5)

    func testVNIA5() {
        let output = typeAndGetOutput("a5")
        XCTAssertEqual(output, "\u{1EA1}", "a5 -> a with dot below")
    }

    // MARK: - Circumflex (6)

    func testVNIA6() {
        // 'a' + '6' = a-circumflex = 0x00E2
        let output = typeAndGetOutput("a6")
        XCTAssertEqual(output, "\u{00E2}", "a6 -> a-circumflex")
    }

    // MARK: - Circumflex + tone

    func testVNIA61() {
        // 'a' + '6' = circumflex, then '1' = acute on circumflex = 0x1EA5
        let slice = typeAndGetLastSlice("a61")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EA5}", "a61 -> a-circumflex with acute")
    }

    // MARK: - D-stroke (9)

    func testVNID9() {
        // 'd' + '9' = d-stroke = 0x0111
        let output = typeAndGetOutput("d9")
        XCTAssertEqual(output, "\u{0111}", "d9 -> d-stroke")
    }

    // MARK: - O-horn (7)

    func testVNIO7() {
        let output = typeAndGetOutput("o7")
        XCTAssertEqual(output, "\u{01A1}", "o7 -> o-horn")
    }

    // MARK: - U-horn (7)

    func testVNIU7() {
        let output = typeAndGetOutput("u7")
        XCTAssertEqual(output, "\u{01B0}", "u7 -> u-horn")
    }

    // MARK: - A-breve (8)

    func testVNIA8() {
        let output = typeAndGetOutput("a8")
        XCTAssertEqual(output, "\u{0103}", "a8 -> a-breve")
    }

    // MARK: - E-circumflex (6)

    func testVNIE6() {
        let output = typeAndGetOutput("e6")
        XCTAssertEqual(output, "\u{00EA}", "e6 -> e-circumflex")
    }

    // MARK: - O-circumflex (6)

    func testVNIO6() {
        let output = typeAndGetOutput("o6")
        XCTAssertEqual(output, "\u{00F4}", "o6 -> o-circumflex")
    }

    // MARK: - Tone on e

    func testVNIE1() {
        let output = typeAndGetOutput("e1")
        XCTAssertEqual(output, "\u{00E9}", "e1 -> e with acute")
    }

    // MARK: - Uppercase

    func testVNIUppercaseA1() {
        let output = typeAndGetOutput("A1")
        XCTAssertEqual(output, "\u{00C1}", "A1 -> A with acute (uppercase)")
    }

    // MARK: - Remove tone (0)

    func testVNIRemoveTone0() {
        // 'a' + '1' = acute, then '0' removes tone
        let slice = typeAndGetLastSlice("a10")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{0061}", "a10 -> plain 'a' (tone removed)")
    }

    // MARK: - Engine reset

    func testEngineResetBetweenWords() {
        _ = typeAndGetOutput("a1")
        engine.clearBuffer()

        let output = typeAndGetOutput("a2")
        XCTAssertEqual(output, "\u{00E0}", "After clearBuffer, new word should work correctly")
    }

    // MARK: - Combined circumflex + tone

    func testVNIA62() {
        // a + 6 (circumflex) + 2 (grave) = a-circumflex-grave = 0x1EA7
        let slice = typeAndGetLastSlice("a62")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EA7}", "a62 -> a-circumflex with grave")
    }
}
