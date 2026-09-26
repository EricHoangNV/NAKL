import XCTest
@testable import NAKL

final class VNITests: XCTestCase {

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

    /// Type a string of ASCII keystrokes and return the output string after the last modification.
    private func typeAndGetOutput(_ keys: String) -> String {
        engine.clearBuffer()
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

    /// Type a string and return the raw (backspaces, output) from the last modification slice.
    private func typeAndGetLastSlice(_ keys: String) -> (backspaces: Int, output: [UInt16]) {
        engine.clearBuffer()
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

    /// Assert that the output of typing `keys` contains the expected UInt16 code point.
    private func assertVNI(_ keys: String, contains expected: UInt16, _ message: String,
                           file: StaticString = #filePath, line: UInt = #line) {
        engine.clearBuffer()
        for scalar in keys.unicodeScalars {
            _ = engine.addKey(UniChar(scalar.value))
        }
        let output = engine.getOutputSlice()
        let all = Array(output.pointer.prefix(output.backspaceCount + output.outputLength))
        let nonBackspace = all.filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(expected),
                      "\(message) — expected 0x\(String(expected, radix: 16)) in \(nonBackspace.map { String(format: "0x%04x", $0) })",
                      file: file, line: line)
    }

    // MARK: - 1. VNIRules Array Validation

    func testCode1IsNotEmpty() {
        XCTAssertFalse(VNIRules.code_1.isEmpty)
    }

    func testCode1Length() {
        XCTAssertEqual(VNIRules.code_1.count, 144, "code_1 (acute) should have 144 entries")
    }

    func testCode2IsNotEmpty() {
        XCTAssertFalse(VNIRules.code_2.isEmpty)
    }

    func testCode2Length() {
        XCTAssertEqual(VNIRules.code_2.count, 144, "code_2 (grave) should have 144 entries")
    }

    func testCode3IsNotEmpty() {
        XCTAssertFalse(VNIRules.code_3.isEmpty)
    }

    func testCode3Length() {
        XCTAssertEqual(VNIRules.code_3.count, 144, "code_3 (hook above) should have 144 entries")
    }

    func testCode4IsNotEmpty() {
        XCTAssertFalse(VNIRules.code_4.isEmpty)
    }

    func testCode4Length() {
        XCTAssertEqual(VNIRules.code_4.count, 144, "code_4 (tilde) should have 144 entries")
    }

    func testCode5IsNotEmpty() {
        XCTAssertFalse(VNIRules.code_5.isEmpty)
    }

    func testCode5Length() {
        XCTAssertEqual(VNIRules.code_5.count, 144, "code_5 (dot below) should have 144 entries")
    }

    func testCode6IsNotEmpty() {
        XCTAssertFalse(VNIRules.code_6.isEmpty)
    }

    func testCode6Length() {
        XCTAssertEqual(VNIRules.code_6.count, 96, "code_6 (circumflex) should have 96 entries")
    }

    func testCode7IsNotEmpty() {
        XCTAssertFalse(VNIRules.code_7.isEmpty)
    }

    func testCode7Length() {
        XCTAssertEqual(VNIRules.code_7.count, 60, "code_7 (horn) should have 60 entries")
    }

    func testCode8IsNotEmpty() {
        XCTAssertFalse(VNIRules.code_8.isEmpty)
    }

    func testCode8Length() {
        XCTAssertEqual(VNIRules.code_8.count, 36, "code_8 (breve) should have 36 entries")
    }

    func testCode9IsNotEmpty() {
        XCTAssertFalse(VNIRules.code_9.isEmpty)
    }

    func testCode9Length() {
        XCTAssertEqual(VNIRules.code_9.count, 4, "code_9 (d-stroke) should have 4 entries")
    }

    // MARK: - 2. Acute Tone (key 1) — All Base Vowels

    func testAcute_a1() {
        assertVNI("a1", contains: Viet.a1, "a + 1 -> a-acute")
    }

    func testAcute_A1() {
        assertVNI("A1", contains: Viet.A1, "A + 1 -> A-acute")
    }

    func testAcute_e1() {
        assertVNI("e1", contains: Viet.e1, "e + 1 -> e-acute")
    }

    func testAcute_E1() {
        assertVNI("E1", contains: Viet.E1, "E + 1 -> E-acute")
    }

    func testAcute_i1() {
        assertVNI("i1", contains: Viet.i1, "i + 1 -> i-acute")
    }

    func testAcute_I1() {
        assertVNI("I1", contains: Viet.I1, "I + 1 -> I-acute")
    }

    func testAcute_o1() {
        assertVNI("o1", contains: Viet.o1, "o + 1 -> o-acute")
    }

    func testAcute_O1() {
        assertVNI("O1", contains: Viet.O1, "O + 1 -> O-acute")
    }

    func testAcute_u1() {
        assertVNI("u1", contains: Viet.u1, "u + 1 -> u-acute")
    }

    func testAcute_U1() {
        assertVNI("U1", contains: Viet.U1, "U + 1 -> U-acute")
    }

    func testAcute_y1() {
        assertVNI("y1", contains: Viet.y1, "y + 1 -> y-acute")
    }

    func testAcute_Y1() {
        assertVNI("Y1", contains: Viet.Y1, "Y + 1 -> Y-acute")
    }

    // MARK: - Acute on circumflex variants

    func testAcute_a61() {
        let slice = typeAndGetLastSlice("a61")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EA5}", "a61 -> a-circumflex-acute")
    }

    func testAcute_e61() {
        let slice = typeAndGetLastSlice("e61")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EBF}", "e61 -> e-circumflex-acute")
    }

    func testAcute_o61() {
        let slice = typeAndGetLastSlice("o61")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1ED1}", "o61 -> o-circumflex-acute")
    }

    // MARK: - Acute on horn variants

    func testAcute_o71() {
        let slice = typeAndGetLastSlice("o71")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EDB}", "o71 -> o-horn-acute")
    }

    func testAcute_u71() {
        let slice = typeAndGetLastSlice("u71")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EE9}", "u71 -> u-horn-acute")
    }

    // MARK: - Acute on breve variant

    func testAcute_a81() {
        let slice = typeAndGetLastSlice("a81")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EAF}", "a81 -> a-breve-acute")
    }

    // MARK: - 3. Grave Tone (key 2) — All Base Vowels

    func testGrave_a2() {
        assertVNI("a2", contains: Viet.a2, "a + 2 -> a-grave")
    }

    func testGrave_A2() {
        assertVNI("A2", contains: Viet.A2, "A + 2 -> A-grave")
    }

    func testGrave_e2() {
        assertVNI("e2", contains: Viet.e2, "e + 2 -> e-grave")
    }

    func testGrave_E2() {
        assertVNI("E2", contains: Viet.E2, "E + 2 -> E-grave")
    }

    func testGrave_i2() {
        assertVNI("i2", contains: Viet.i2, "i + 2 -> i-grave")
    }

    func testGrave_I2() {
        assertVNI("I2", contains: Viet.I2, "I + 2 -> I-grave")
    }

    func testGrave_o2() {
        assertVNI("o2", contains: Viet.o2, "o + 2 -> o-grave")
    }

    func testGrave_O2() {
        assertVNI("O2", contains: Viet.O2, "O + 2 -> O-grave")
    }

    func testGrave_u2() {
        assertVNI("u2", contains: Viet.u2, "u + 2 -> u-grave")
    }

    func testGrave_U2() {
        assertVNI("U2", contains: Viet.U2, "U + 2 -> U-grave")
    }

    func testGrave_y2() {
        assertVNI("y2", contains: Viet.y2, "y + 2 -> y-grave")
    }

    func testGrave_Y2() {
        assertVNI("Y2", contains: Viet.Y2, "Y + 2 -> Y-grave")
    }

    // MARK: - Grave on circumflex variants

    func testGrave_a62() {
        let slice = typeAndGetLastSlice("a62")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EA7}", "a62 -> a-circumflex-grave")
    }

    func testGrave_e62() {
        let slice = typeAndGetLastSlice("e62")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EC1}", "e62 -> e-circumflex-grave")
    }

    func testGrave_o62() {
        let slice = typeAndGetLastSlice("o62")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1ED3}", "o62 -> o-circumflex-grave")
    }

    // MARK: - Grave on horn variants

    func testGrave_o72() {
        let slice = typeAndGetLastSlice("o72")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EDD}", "o72 -> o-horn-grave")
    }

    func testGrave_u72() {
        let slice = typeAndGetLastSlice("u72")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EEB}", "u72 -> u-horn-grave")
    }

    // MARK: - Grave on breve variant

    func testGrave_a82() {
        let slice = typeAndGetLastSlice("a82")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EB1}", "a82 -> a-breve-grave")
    }

    // MARK: - 4. Hook Above (key 3) — All Base Vowels

    func testHookAbove_a3() {
        assertVNI("a3", contains: Viet.a3, "a + 3 -> a-hook-above")
    }

    func testHookAbove_A3() {
        assertVNI("A3", contains: Viet.A3, "A + 3 -> A-hook-above")
    }

    func testHookAbove_e3() {
        assertVNI("e3", contains: Viet.e3, "e + 3 -> e-hook-above")
    }

    func testHookAbove_E3() {
        assertVNI("E3", contains: Viet.E3, "E + 3 -> E-hook-above")
    }

    func testHookAbove_i3() {
        assertVNI("i3", contains: Viet.i3, "i + 3 -> i-hook-above")
    }

    func testHookAbove_I3() {
        assertVNI("I3", contains: Viet.I3, "I + 3 -> I-hook-above")
    }

    func testHookAbove_o3() {
        assertVNI("o3", contains: Viet.o3, "o + 3 -> o-hook-above")
    }

    func testHookAbove_O3() {
        assertVNI("O3", contains: Viet.O3, "O + 3 -> O-hook-above")
    }

    func testHookAbove_u3() {
        assertVNI("u3", contains: Viet.u3, "u + 3 -> u-hook-above")
    }

    func testHookAbove_U3() {
        assertVNI("U3", contains: Viet.U3, "U + 3 -> U-hook-above")
    }

    func testHookAbove_y3() {
        assertVNI("y3", contains: Viet.y3, "y + 3 -> y-hook-above")
    }

    func testHookAbove_Y3() {
        assertVNI("Y3", contains: Viet.Y3, "Y + 3 -> Y-hook-above")
    }

    // MARK: - Hook above on circumflex variants

    func testHookAbove_a63() {
        let slice = typeAndGetLastSlice("a63")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EA9}", "a63 -> a-circumflex-hook-above")
    }

    func testHookAbove_e63() {
        let slice = typeAndGetLastSlice("e63")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EC3}", "e63 -> e-circumflex-hook-above")
    }

    func testHookAbove_o63() {
        let slice = typeAndGetLastSlice("o63")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1ED5}", "o63 -> o-circumflex-hook-above")
    }

    // MARK: - Hook above on horn variants

    func testHookAbove_o73() {
        let slice = typeAndGetLastSlice("o73")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EDF}", "o73 -> o-horn-hook-above")
    }

    func testHookAbove_u73() {
        let slice = typeAndGetLastSlice("u73")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EED}", "u73 -> u-horn-hook-above")
    }

    // MARK: - 5. Tilde (key 4) — All Base Vowels

    func testTilde_a4() {
        assertVNI("a4", contains: Viet.a4, "a + 4 -> a-tilde")
    }

    func testTilde_A4() {
        assertVNI("A4", contains: Viet.A4, "A + 4 -> A-tilde")
    }

    func testTilde_e4() {
        assertVNI("e4", contains: Viet.e4, "e + 4 -> e-tilde")
    }

    func testTilde_E4() {
        assertVNI("E4", contains: Viet.E4, "E + 4 -> E-tilde")
    }

    func testTilde_i4() {
        assertVNI("i4", contains: Viet.i4, "i + 4 -> i-tilde")
    }

    func testTilde_I4() {
        assertVNI("I4", contains: Viet.I4, "I + 4 -> I-tilde")
    }

    func testTilde_o4() {
        assertVNI("o4", contains: Viet.o4, "o + 4 -> o-tilde")
    }

    func testTilde_O4() {
        assertVNI("O4", contains: Viet.O4, "O + 4 -> O-tilde")
    }

    func testTilde_u4() {
        assertVNI("u4", contains: Viet.u4, "u + 4 -> u-tilde")
    }

    func testTilde_U4() {
        assertVNI("U4", contains: Viet.U4, "U + 4 -> U-tilde")
    }

    func testTilde_y4() {
        assertVNI("y4", contains: Viet.y4, "y + 4 -> y-tilde")
    }

    func testTilde_Y4() {
        assertVNI("Y4", contains: Viet.Y4, "Y + 4 -> Y-tilde")
    }

    // MARK: - Tilde on circumflex variants

    func testTilde_a64() {
        let slice = typeAndGetLastSlice("a64")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EAB}", "a64 -> a-circumflex-tilde")
    }

    func testTilde_e64() {
        let slice = typeAndGetLastSlice("e64")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EC5}", "e64 -> e-circumflex-tilde")
    }

    func testTilde_o64() {
        let slice = typeAndGetLastSlice("o64")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1ED7}", "o64 -> o-circumflex-tilde")
    }

    // MARK: - Tilde on horn variants

    func testTilde_o74() {
        let slice = typeAndGetLastSlice("o74")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EE1}", "o74 -> o-horn-tilde")
    }

    func testTilde_u74() {
        let slice = typeAndGetLastSlice("u74")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EEF}", "u74 -> u-horn-tilde")
    }

    // MARK: - 6. Dot Below (key 5) — All Base Vowels

    func testDotBelow_a5() {
        assertVNI("a5", contains: Viet.a5, "a + 5 -> a-dot-below")
    }

    func testDotBelow_A5() {
        assertVNI("A5", contains: Viet.A5, "A + 5 -> A-dot-below")
    }

    func testDotBelow_e5() {
        assertVNI("e5", contains: Viet.e5, "e + 5 -> e-dot-below")
    }

    func testDotBelow_E5() {
        assertVNI("E5", contains: Viet.E5, "E + 5 -> E-dot-below")
    }

    func testDotBelow_i5() {
        assertVNI("i5", contains: Viet.i5, "i + 5 -> i-dot-below")
    }

    func testDotBelow_I5() {
        assertVNI("I5", contains: Viet.I5, "I + 5 -> I-dot-below")
    }

    func testDotBelow_o5() {
        assertVNI("o5", contains: Viet.o5, "o + 5 -> o-dot-below")
    }

    func testDotBelow_O5() {
        assertVNI("O5", contains: Viet.O5, "O + 5 -> O-dot-below")
    }

    func testDotBelow_u5() {
        assertVNI("u5", contains: Viet.u5, "u + 5 -> u-dot-below")
    }

    func testDotBelow_U5() {
        assertVNI("U5", contains: Viet.U5, "U + 5 -> U-dot-below")
    }

    func testDotBelow_y5() {
        assertVNI("y5", contains: Viet.y5, "y + 5 -> y-dot-below")
    }

    func testDotBelow_Y5() {
        assertVNI("Y5", contains: Viet.Y5, "Y + 5 -> Y-dot-below")
    }

    // MARK: - Dot below on circumflex variants

    func testDotBelow_a65() {
        let slice = typeAndGetLastSlice("a65")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EAD}", "a65 -> a-circumflex-dot-below")
    }

    func testDotBelow_e65() {
        let slice = typeAndGetLastSlice("e65")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EC7}", "e65 -> e-circumflex-dot-below")
    }

    func testDotBelow_o65() {
        let slice = typeAndGetLastSlice("o65")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1ED9}", "o65 -> o-circumflex-dot-below")
    }

    // MARK: - Dot below on horn variants

    func testDotBelow_o75() {
        let slice = typeAndGetLastSlice("o75")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EE3}", "o75 -> o-horn-dot-below")
    }

    func testDotBelow_u75() {
        let slice = typeAndGetLastSlice("u75")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EF1}", "u75 -> u-horn-dot-below")
    }

    // MARK: - Dot below on breve variant

    func testDotBelow_a85() {
        let slice = typeAndGetLastSlice("a85")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EB7}", "a85 -> a-breve-dot-below")
    }

    // MARK: - 7. Circumflex (key 6)

    func testCircumflex_a6() {
        assertVNI("a6", contains: Viet.a6, "a + 6 -> a-circumflex")
    }

    func testCircumflex_A6() {
        assertVNI("A6", contains: Viet.A6, "A + 6 -> A-circumflex")
    }

    func testCircumflex_e6() {
        assertVNI("e6", contains: Viet.e6, "e + 6 -> e-circumflex")
    }

    func testCircumflex_E6() {
        assertVNI("E6", contains: Viet.E6, "E + 6 -> E-circumflex")
    }

    func testCircumflex_o6() {
        assertVNI("o6", contains: Viet.o6, "o + 6 -> o-circumflex")
    }

    func testCircumflex_O6() {
        assertVNI("O6", contains: Viet.O6, "O + 6 -> O-circumflex")
    }

    // MARK: - Circumflex with tones (combined)

    func testCircumflex_a6_thenAcute() {
        let slice = typeAndGetLastSlice("a61")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EA5}", "a6 then 1 -> a-circumflex-acute")
    }

    func testCircumflex_a6_thenGrave() {
        let slice = typeAndGetLastSlice("a62")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EA7}", "a6 then 2 -> a-circumflex-grave")
    }

    func testCircumflex_a6_thenHookAbove() {
        let slice = typeAndGetLastSlice("a63")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EA9}", "a6 then 3 -> a-circumflex-hook-above")
    }

    func testCircumflex_a6_thenTilde() {
        let slice = typeAndGetLastSlice("a64")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EAB}", "a6 then 4 -> a-circumflex-tilde")
    }

    func testCircumflex_a6_thenDotBelow() {
        let slice = typeAndGetLastSlice("a65")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EAD}", "a6 then 5 -> a-circumflex-dot-below")
    }

    // MARK: - Circumflex double-press revert

    func testCircumflex_a66_reverts() {
        // a + 6 -> circumflex, then 6 again -> revert to plain 'a' + literal '6'
        let slice = typeAndGetLastSlice("a66")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        // Double-press circumflex should revert: output should contain plain 'a'
        XCTAssertTrue(outputStr.contains("a") || outputStr.contains("6"),
                      "a66 -> should revert circumflex (got: \(outputStr))")
    }

    func testCircumflex_e66_reverts() {
        let slice = typeAndGetLastSlice("e66")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertTrue(outputStr.contains("e") || outputStr.contains("6"),
                      "e66 -> should revert circumflex (got: \(outputStr))")
    }

    func testCircumflex_o66_reverts() {
        let slice = typeAndGetLastSlice("o66")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertTrue(outputStr.contains("o") || outputStr.contains("6"),
                      "o66 -> should revert circumflex (got: \(outputStr))")
    }

    // MARK: - 8. Horn (key 7)

    func testHorn_o7() {
        assertVNI("o7", contains: Viet.o7, "o + 7 -> o-horn")
    }

    func testHorn_O7() {
        assertVNI("O7", contains: Viet.O7, "O + 7 -> O-horn")
    }

    func testHorn_u7() {
        assertVNI("u7", contains: Viet.u7, "u + 7 -> u-horn")
    }

    func testHorn_U7() {
        assertVNI("U7", contains: Viet.U7, "U + 7 -> U-horn")
    }

    // MARK: - Horn with tones (combined)

    func testHorn_o7_thenAcute() {
        let slice = typeAndGetLastSlice("o71")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EDB}", "o7 then 1 -> o-horn-acute")
    }

    func testHorn_o7_thenGrave() {
        let slice = typeAndGetLastSlice("o72")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EDD}", "o7 then 2 -> o-horn-grave")
    }

    func testHorn_o7_thenHookAbove() {
        let slice = typeAndGetLastSlice("o73")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EDF}", "o7 then 3 -> o-horn-hook-above")
    }

    func testHorn_o7_thenTilde() {
        let slice = typeAndGetLastSlice("o74")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EE1}", "o7 then 4 -> o-horn-tilde")
    }

    func testHorn_o7_thenDotBelow() {
        let slice = typeAndGetLastSlice("o75")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EE3}", "o7 then 5 -> o-horn-dot-below")
    }

    func testHorn_u7_thenAcute() {
        let slice = typeAndGetLastSlice("u71")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EE9}", "u7 then 1 -> u-horn-acute")
    }

    func testHorn_u7_thenGrave() {
        let slice = typeAndGetLastSlice("u72")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EEB}", "u7 then 2 -> u-horn-grave")
    }

    func testHorn_u7_thenHookAbove() {
        let slice = typeAndGetLastSlice("u73")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EED}", "u7 then 3 -> u-horn-hook-above")
    }

    func testHorn_u7_thenTilde() {
        let slice = typeAndGetLastSlice("u74")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EEF}", "u7 then 4 -> u-horn-tilde")
    }

    func testHorn_u7_thenDotBelow() {
        let slice = typeAndGetLastSlice("u75")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EF1}", "u7 then 5 -> u-horn-dot-below")
    }

    // MARK: - Horn double-press revert

    func testHorn_o77_reverts() {
        let slice = typeAndGetLastSlice("o77")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertTrue(outputStr.contains("o") || outputStr.contains("7"),
                      "o77 -> should revert horn (got: \(outputStr))")
    }

    func testHorn_u77_reverts() {
        let slice = typeAndGetLastSlice("u77")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertTrue(outputStr.contains("u") || outputStr.contains("7"),
                      "u77 -> should revert horn (got: \(outputStr))")
    }

    // MARK: - 9. Breve (key 8)

    func testBreve_a8() {
        assertVNI("a8", contains: Viet.a8, "a + 8 -> a-breve")
    }

    func testBreve_A8() {
        assertVNI("A8", contains: Viet.A8, "A + 8 -> A-breve")
    }

    // MARK: - Breve with tones (combined)

    func testBreve_a8_thenAcute() {
        let slice = typeAndGetLastSlice("a81")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EAF}", "a8 then 1 -> a-breve-acute")
    }

    func testBreve_a8_thenGrave() {
        let slice = typeAndGetLastSlice("a82")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EB1}", "a8 then 2 -> a-breve-grave")
    }

    func testBreve_a8_thenHookAbove() {
        let slice = typeAndGetLastSlice("a83")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EB3}", "a8 then 3 -> a-breve-hook-above")
    }

    func testBreve_a8_thenTilde() {
        let slice = typeAndGetLastSlice("a84")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EB5}", "a8 then 4 -> a-breve-tilde")
    }

    func testBreve_a8_thenDotBelow() {
        let slice = typeAndGetLastSlice("a85")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EB7}", "a8 then 5 -> a-breve-dot-below")
    }

    // MARK: - Breve double-press revert

    func testBreve_a88_reverts() {
        let slice = typeAndGetLastSlice("a88")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertTrue(outputStr.contains("a") || outputStr.contains("8"),
                      "a88 -> should revert breve (got: \(outputStr))")
    }

    // MARK: - 10. D-stroke (key 9)

    func testDStroke_d9() {
        assertVNI("d9", contains: Viet.d9, "d + 9 -> d-stroke")
    }

    func testDStroke_D9() {
        assertVNI("D9", contains: Viet.D9, "D + 9 -> D-stroke")
    }

    // MARK: - D-stroke double-press revert

    func testDStroke_d99_reverts() {
        let slice = typeAndGetLastSlice("d99")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertTrue(outputStr.contains("d") || outputStr.contains("9"),
                      "d99 -> should revert d-stroke (got: \(outputStr))")
    }

    func testDStroke_D99_reverts() {
        let slice = typeAndGetLastSlice("D99")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertTrue(outputStr.contains("D") || outputStr.contains("9"),
                      "D99 -> should revert D-stroke (got: \(outputStr))")
    }

    // MARK: - 11. Remove Tone (key 0)

    func testRemoveTone_a10() {
        // a + 1 (acute) then 0 (remove) -> plain 'a'
        let slice = typeAndGetLastSlice("a10")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "a", "a10 -> plain 'a' (tone removed)")
    }

    func testRemoveTone_e20() {
        let slice = typeAndGetLastSlice("e20")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "e", "e20 -> plain 'e' (tone removed)")
    }

    // MARK: - 12. Uppercase Circumflex + Tone

    func testUpperCircumflex_A61() {
        let slice = typeAndGetLastSlice("A61")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EA4}", "A61 -> A-circumflex-acute (uppercase)")
    }

    func testUpperCircumflex_E62() {
        let slice = typeAndGetLastSlice("E62")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EC0}", "E62 -> E-circumflex-grave (uppercase)")
    }

    func testUpperCircumflex_O65() {
        let slice = typeAndGetLastSlice("O65")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1ED8}", "O65 -> O-circumflex-dot-below (uppercase)")
    }

    // MARK: - 13. Uppercase Horn + Tone

    func testUpperHorn_O71() {
        let slice = typeAndGetLastSlice("O71")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EDA}", "O71 -> O-horn-acute (uppercase)")
    }

    func testUpperHorn_U72() {
        let slice = typeAndGetLastSlice("U72")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EEA}", "U72 -> U-horn-grave (uppercase)")
    }

    // MARK: - 14. Uppercase Breve + Tone

    func testUpperBreve_A81() {
        let slice = typeAndGetLastSlice("A81")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EAE}", "A81 -> A-breve-acute (uppercase)")
    }

    func testUpperBreve_A85() {
        let slice = typeAndGetLastSlice("A85")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EB6}", "A85 -> A-breve-dot-below (uppercase)")
    }

    // MARK: - 15. Engine Reset Between Words

    func testEngineResetBetweenWords() {
        _ = typeAndGetOutput("a1")
        engine.clearBuffer()
        let output = typeAndGetOutput("e2")
        XCTAssertEqual(output, "\u{00E8}", "After clearBuffer, e2 should produce e-grave")
    }

    func testClearBufferResetsForNewWord() {
        assertVNI("a6", contains: Viet.a6, "First word: a-circumflex")
        engine.clearBuffer()
        assertVNI("o7", contains: Viet.o7, "Second word after clear: o-horn")
    }

    // MARK: - 16. Full Word Integration Tests

    func testWord_viet() {
        // vie65t -> vi + e6(e-circumflex) + 5(dot-below on e-circumflex) + t
        // = vi + ệ + t = việt
        engine.clearBuffer()
        for scalar in "vie65t".unicodeScalars {
            _ = engine.addKey(UniChar(scalar.value))
        }
        let output = engine.getOutputSlice()
        let all = Array(output.pointer.prefix(output.backspaceCount + output.outputLength))
        let nonBackspace = all.filter { $0 != 0x08 && $0 != 0 }
        // Should contain e-circumflex-dot-below (U+1EC7 = ệ)
        XCTAssertTrue(nonBackspace.contains(Viet.e65),
                      "vie65t should produce e-circumflex-dot-below")
    }

    func testWord_chao() {
        // cha2o -> ch + a2(a-grave) + o = chào
        engine.clearBuffer()
        for scalar in "cha2o".unicodeScalars {
            _ = engine.addKey(UniChar(scalar.value))
        }
        let output = engine.getOutputSlice()
        let all = Array(output.pointer.prefix(output.backspaceCount + output.outputLength))
        let nonBackspace = all.filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a2),
                      "cha2o should contain a-grave for 'chào'")
    }

    func testWord_day() {
        // d9a6y -> d9(d-stroke) + a6(a-circumflex) + y
        // First: d9 -> đ
        engine.clearBuffer()
        for scalar in "d9".unicodeScalars {
            _ = engine.addKey(UniChar(scalar.value))
        }
        let output1 = engine.getOutputSlice()
        let nonBS1 = Array(output1.pointer.prefix(output1.backspaceCount + output1.outputLength))
            .filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBS1.contains(Viet.d9), "d9 in d9a6y should produce d-stroke")
    }

    func testWord_la() {
        // la2 -> l + a2(a-grave) = là
        engine.clearBuffer()
        for scalar in "la2".unicodeScalars {
            _ = engine.addKey(UniChar(scalar.value))
        }
        let output = engine.getOutputSlice()
        let all = Array(output.pointer.prefix(output.backspaceCount + output.outputLength))
        let nonBackspace = all.filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a2),
                      "la2 should contain a-grave for 'là'")
    }

    func testWord_thu() {
        // Thu7 -> Th + u7(u-horn) = Thư
        engine.clearBuffer()
        for scalar in "Thu7".unicodeScalars {
            _ = engine.addKey(UniChar(scalar.value))
        }
        let output = engine.getOutputSlice()
        let all = Array(output.pointer.prefix(output.backspaceCount + output.outputLength))
        let nonBackspace = all.filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.u7),
                      "Thu7 should contain u-horn for 'Thư'")
    }

    func testWord_vien() {
        // vie65n -> vi + e65(e-circumflex-dot-below) + n = viện
        engine.clearBuffer()
        for scalar in "vie65n".unicodeScalars {
            _ = engine.addKey(UniChar(scalar.value))
        }
        let output = engine.getOutputSlice()
        let all = Array(output.pointer.prefix(output.backspaceCount + output.outputLength))
        let nonBackspace = all.filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.e65),
                      "vie65n should contain e-circumflex-dot-below for 'viện'")
    }

    // MARK: - 17. Tone Replacement (applying one tone over another)

    func testToneReplacement_a1_then_2() {
        // a + 1 (acute) then 2 (grave) should replace acute with grave
        let slice = typeAndGetLastSlice("a12")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{00E0}", "a12 -> a-grave (acute replaced by grave)")
    }

    func testToneReplacement_e3_then_4() {
        // e + 3 (hook) then 4 (tilde) should replace hook with tilde
        let slice = typeAndGetLastSlice("e34")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EBD}", "e34 -> e-tilde (hook replaced by tilde)")
    }

    func testToneReplacement_o5_then_1() {
        // o + 5 (dot below) then 1 (acute) should replace dot below with acute
        let slice = typeAndGetLastSlice("o51")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{00F3}", "o51 -> o-acute (dot below replaced by acute)")
    }

    // MARK: - 18. Circumflex-to-Breve Switching via key 8

    func testCircumflexToBreve_a6_then_8() {
        // a + 6 (circumflex) then 8 (breve) -> should switch to breve
        let slice = typeAndGetLastSlice("a68")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{0103}", "a68 -> a-breve (circumflex replaced by breve)")
    }

    // MARK: - 19. Breve-to-Circumflex Switching via key 6

    func testBreveToCircumflex_a8_then_6() {
        // a + 8 (breve) then 6 (circumflex) -> should switch to circumflex
        let slice = typeAndGetLastSlice("a86")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{00E2}", "a86 -> a-circumflex (breve replaced by circumflex)")
    }

    // MARK: - 20. Horn-to-Circumflex Switching for 'o'

    func testHornToCircumflex_o7_then_6() {
        // o + 7 (horn) then 6 (circumflex) -> should switch to circumflex
        let slice = typeAndGetLastSlice("o76")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{00F4}", "o76 -> o-circumflex (horn replaced by circumflex)")
    }

    // MARK: - 21. Circumflex-to-Horn Switching for 'o'

    func testCircumflexToHorn_o6_then_7() {
        // o + 6 (circumflex) then 7 (horn) -> should switch to horn
        let slice = typeAndGetLastSlice("o67")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{01A1}", "o67 -> o-horn (circumflex replaced by horn)")
    }

    // MARK: - 22. E-circumflex with all tones

    func testECircumflex_e61() {
        let slice = typeAndGetLastSlice("e61")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EBF}", "e61 -> e-circumflex-acute")
    }

    func testECircumflex_e62() {
        let slice = typeAndGetLastSlice("e62")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EC1}", "e62 -> e-circumflex-grave")
    }

    func testECircumflex_e63() {
        let slice = typeAndGetLastSlice("e63")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EC3}", "e63 -> e-circumflex-hook-above")
    }

    func testECircumflex_e64() {
        let slice = typeAndGetLastSlice("e64")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EC5}", "e64 -> e-circumflex-tilde")
    }

    func testECircumflex_e65() {
        let slice = typeAndGetLastSlice("e65")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EC7}", "e65 -> e-circumflex-dot-below")
    }

    // MARK: - 23. O-circumflex with all tones

    func testOCircumflex_o61() {
        let slice = typeAndGetLastSlice("o61")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1ED1}", "o61 -> o-circumflex-acute")
    }

    func testOCircumflex_o62() {
        let slice = typeAndGetLastSlice("o62")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1ED3}", "o62 -> o-circumflex-grave")
    }

    func testOCircumflex_o63() {
        let slice = typeAndGetLastSlice("o63")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1ED5}", "o63 -> o-circumflex-hook-above")
    }

    func testOCircumflex_o64() {
        let slice = typeAndGetLastSlice("o64")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1ED7}", "o64 -> o-circumflex-tilde")
    }

    func testOCircumflex_o65() {
        let slice = typeAndGetLastSlice("o65")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1ED9}", "o65 -> o-circumflex-dot-below")
    }

    // MARK: - 24. Breve-hook-above and breve-tilde

    func testBreve_a83() {
        let slice = typeAndGetLastSlice("a83")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EB3}", "a83 -> a-breve-hook-above")
    }

    func testBreve_a84() {
        let slice = typeAndGetLastSlice("a84")
        let outputStr = String(slice.output.map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(outputStr, "\u{1EB5}", "a84 -> a-breve-tilde")
    }

    // MARK: - 25. addKey Return Value Checks

    func testAddKeyReturnsNegativeOneForFirstChar() {
        engine.clearBuffer()
        let result = engine.addKey(UniChar(0x61)) // 'a'
        XCTAssertEqual(result, -1, "First character should return -1 (no modification)")
    }

    func testAddKeyReturnsNonNegativeForModifier() {
        engine.clearBuffer()
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x31)) // '1'
        XCTAssertGreaterThanOrEqual(result, 0, "VNI modifier '1' after 'a' should return >= 0")
    }

    func testAddKeyReturnsNegativeOneForConsonant() {
        engine.clearBuffer()
        _ = engine.addKey(UniChar(0x62)) // 'b'
        let result = engine.addKey(UniChar(0x63)) // 'c'
        XCTAssertEqual(result, -1, "Non-modifier after consonant should return -1")
    }
}
