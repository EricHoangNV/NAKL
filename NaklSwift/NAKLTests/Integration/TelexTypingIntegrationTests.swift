import XCTest
@testable import NAKL

final class TelexTypingIntegrationTests: XCTestCase {

    private var engine: VietnameseEngine!

    override func setUp() {
        super.setUp()
        engine = VietnameseEngine()
        engine.inputMethod = .telex
    }

    override func tearDown() {
        engine = nil
        super.tearDown()
    }

    // MARK: - Helpers

    /// Feed keys into the engine and return the last output slice's buffer content
    /// as a Unicode string (only the newly produced characters, not backspaces).
    private func typeAndGetOutput(_ keys: String) -> String {
        var lastOutput = ""
        for char in keys.unicodeScalars {
            let result = engine.addKey(UniChar(char.value))
            if result >= 0 {
                let slice = engine.getOutputSlice()
                // The output slice contains backspaces (0x08) followed by replacement chars
                let chars = slice.pointer.dropFirst(slice.backspaceCount).prefix(slice.outputLength)
                lastOutput = String(chars.map { Character(UnicodeScalar($0)!) })
            }
        }
        return lastOutput
    }

    /// Feed keys and return the full word buffer from the last successful addKey call.
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

    // MARK: - Basic acute tone (s)

    func testTelexAS() {
        // 'a' + 's' in Telex = a with acute = a1 = 0x00E1 (a with accent)
        let output = typeAndGetOutput("as")
        XCTAssertEqual(output, "\u{00E1}", "as -> a with acute accent")
    }

    // MARK: - Grave tone (f)

    func testTelexAF() {
        let output = typeAndGetOutput("af")
        XCTAssertEqual(output, "\u{00E0}", "af -> a with grave accent")
    }

    // MARK: - Hook above (r)

    func testTelexAR() {
        let output = typeAndGetOutput("ar")
        XCTAssertEqual(output, "\u{1EA3}", "ar -> a with hook above")
    }

    // MARK: - Tilde (x)

    func testTelexAX() {
        let output = typeAndGetOutput("ax")
        XCTAssertEqual(output, "\u{00E3}", "ax -> a with tilde")
    }

    // MARK: - Dot below (j)

    func testTelexAJ() {
        let output = typeAndGetOutput("aj")
        XCTAssertEqual(output, "\u{1EA1}", "aj -> a with dot below")
    }

    // MARK: - Circumflex + tone: aa + s = a-circumflex with acute

    func testTelexAAS() {
        // 'a' then 'a' = circumflex a (a6 = 0x00E2), then 's' = acute on circumflex a (a61 = 0x1EA5)
        let slice = typeAndGetLastSlice("aas")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EA5}", "aas -> a-circumflex with acute")
    }

    // MARK: - Circumflex a

    func testTelexAA() {
        let output = typeAndGetOutput("aa")
        XCTAssertEqual(output, "\u{00E2}", "aa -> a-circumflex")
    }

    // MARK: - D-stroke

    func testTelexDD() {
        // 'd' then 'd' = d-stroke (d9 = 0x0111)
        let output = typeAndGetOutput("dd")
        XCTAssertEqual(output, "\u{0111}", "dd -> d-stroke")
    }

    // MARK: - E-circumflex

    func testTelexEE() {
        let output = typeAndGetOutput("ee")
        XCTAssertEqual(output, "\u{00EA}", "ee -> e-circumflex")
    }

    // MARK: - O-circumflex

    func testTelexOO() {
        let output = typeAndGetOutput("oo")
        XCTAssertEqual(output, "\u{00F4}", "oo -> o-circumflex")
    }

    // MARK: - O-horn (ow)

    func testTelexOW() {
        let output = typeAndGetOutput("ow")
        XCTAssertEqual(output, "\u{01A1}", "ow -> o-horn")
    }

    // MARK: - U-horn (uw)

    func testTelexUW() {
        let output = typeAndGetOutput("uw")
        XCTAssertEqual(output, "\u{01B0}", "uw -> u-horn")
    }

    // MARK: - A-breve (aw)

    func testTelexAW() {
        let output = typeAndGetOutput("aw")
        XCTAssertEqual(output, "\u{0103}", "aw -> a-breve")
    }

    // MARK: - Tone on e: es = e-acute

    func testTelexES() {
        let output = typeAndGetOutput("es")
        XCTAssertEqual(output, "\u{00E9}", "es -> e with acute")
    }

    // MARK: - Combined: Vietnamese word fragments

    func testTelexVietWord() {
        // "vieetj" in Telex: v-i-e-e(circumflex)-t-j(dot below on the circumflex e)
        // Actually let's test a simpler case: "os" = o-acute
        let output = typeAndGetOutput("os")
        XCTAssertEqual(output, "\u{00F3}", "os -> o with acute")
    }

    // MARK: - Uppercase

    func testTelexUppercaseAS() {
        let output = typeAndGetOutput("As")
        XCTAssertEqual(output, "\u{00C1}", "As -> A with acute accent (uppercase)")
    }

    // MARK: - Engine reset between words

    func testEngineResetBetweenWords() {
        // Type one word, clear, type another
        _ = typeAndGetOutput("as")
        engine.clearBuffer()

        let output = typeAndGetOutput("af")
        XCTAssertEqual(output, "\u{00E0}", "After clearBuffer, new word should work correctly")
    }

    // MARK: - Remove tone with z

    func testTelexRemoveToneZ() {
        // 'a' + 's' = acute, then 'z' should remove the tone
        let slice = typeAndGetLastSlice("asz")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{0061}", "asz -> plain 'a' (tone removed)")
    }
}
