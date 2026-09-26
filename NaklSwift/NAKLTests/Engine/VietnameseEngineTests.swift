import XCTest
@testable import NAKL

final class VietnameseEngineTests: XCTestCase {

    private var engine: VietnameseEngine!

    override func setUp() {
        super.setUp()
        engine = VietnameseEngine()
    }

    override func tearDown() {
        engine = nil
        super.tearDown()
    }

    // MARK: - Helper

    /// Feeds a string of ASCII keystrokes into the engine and returns the
    /// output buffer as a Unicode string after each key that triggers a modification.
    /// Returns the full output slice content after all keys are processed.
    private func typeKeys(_ keys: String, method: InputMethod = .telex) -> String {
        engine.clearBuffer()
        engine.inputMethod = method
        for scalar in keys.unicodeScalars {
            let key = UniChar(scalar.value)
            _ = engine.addKey(key)
        }
        let output = engine.getOutputSlice()
        if output.outputLength == 0 && output.backspaceCount == 0 {
            return ""
        }
        let chars = output.pointer.prefix(output.backspaceCount + output.outputLength)
        return String(
            chars.compactMap { code -> Character? in
                guard code != 0x08, code != 0 else { return nil }
                return Character(UnicodeScalar(UInt32(code))!)
            }
        )
    }

    /// Returns the raw UInt16 values from the output slice (non-backspace portion).
    private func typeKeysRaw(_ keys: String, method: InputMethod = .telex) -> [UInt16] {
        engine.clearBuffer()
        engine.inputMethod = method
        var lastResult = -1
        for scalar in keys.unicodeScalars {
            let key = UniChar(scalar.value)
            lastResult = engine.addKey(key)
        }
        let output = engine.getOutputSlice()
        if output.outputLength == 0 {
            return []
        }
        // The output portion starts after backspaceCount entries
        return Array(output.pointer.suffix(output.outputLength).prefix(while: { $0 != 0 }))
    }

    // MARK: - Engine initialization

    func testInitialState() {
        XCTAssertEqual(engine.kbBLength, 0)
        XCTAssertEqual(engine.kbPLength, 0)
    }

    func testInputMethodDefault() {
        XCTAssertEqual(engine.inputMethod, .telex)
    }

    // MARK: - Clear buffer

    func testClearBufferResetsState() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        engine.clearBuffer()
        XCTAssertEqual(engine.kbBLength, 0)
        XCTAssertEqual(engine.kbPLength, 0)
    }

    // MARK: - Off mode

    func testOffModeReturnsNegativeOne() {
        engine.inputMethod = .off
        let result = engine.addKey(UniChar(0x61)) // 'a'
        XCTAssertEqual(result, -1)
    }

    func testOffModeDoesNotModify() {
        engine.inputMethod = .off
        _ = engine.addKey(UniChar(0x61)) // 'a'
        _ = engine.addKey(UniChar(0x73)) // 's'
        let output = engine.getOutputSlice()
        XCTAssertEqual(output.outputLength, 0)
    }

    // MARK: - Telex tone marks

    func testTelexAcute_as() {
        // 'a' then 's' should produce acute 'a' (a1 = 0x00E1)
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x73)) // 's'
        XCTAssertGreaterThanOrEqual(result, 0, "Modifier should have been applied")
        let output = engine.getOutputSlice()
        // The output should contain the modified character
        XCTAssertGreaterThan(output.outputLength, 0)
        let outputChars = Array(output.pointer.prefix(output.backspaceCount + output.outputLength))
        let nonBackspace = outputChars.filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a1), "Output should contain a-acute (0x\(String(Viet.a1, radix: 16)))")
    }

    func testTelexGrave_af() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x66)) // 'f'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a2), "Output should contain a-grave")
    }

    func testTelexHookAbove_ar() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x72)) // 'r'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a3), "Output should contain a-hook-above")
    }

    func testTelexTilde_ax() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x78)) // 'x'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a4), "Output should contain a-tilde")
    }

    func testTelexDotBelow_aj() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x6A)) // 'j'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a5), "Output should contain a-dot-below")
    }

    // MARK: - Telex circumflex

    func testTelexCircumflex_aa() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x61)) // 'a'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a6), "Output should contain a-circumflex")
    }

    func testTelexCircumflex_ee() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x65)) // 'e'
        let result = engine.addKey(UniChar(0x65)) // 'e'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.e6), "Output should contain e-circumflex")
    }

    func testTelexCircumflex_oo() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x6F)) // 'o'
        let result = engine.addKey(UniChar(0x6F)) // 'o'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.o6), "Output should contain o-circumflex")
    }

    // MARK: - Telex breve and horn

    func testTelexBreve_aw() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x77)) // 'w'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a8), "Output should contain a-breve")
    }

    func testTelexHorn_ow() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x6F)) // 'o'
        let result = engine.addKey(UniChar(0x77)) // 'w'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.o7), "Output should contain o-horn")
    }

    func testTelexHorn_uw() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x75)) // 'u'
        let result = engine.addKey(UniChar(0x77)) // 'w'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.u7), "Output should contain u-horn")
    }

    // MARK: - Telex d-bar

    func testTelexDBar_dd() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x64)) // 'd'
        let result = engine.addKey(UniChar(0x64)) // 'd'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.d9), "Output should contain d-bar")
    }

    // MARK: - Telex combined diacritics

    func testTelexCircumflexPlusAcute_aas() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        _ = engine.addKey(UniChar(0x61)) // 'a' -> circumflex
        let result = engine.addKey(UniChar(0x73)) // 's' -> acute on circumflex
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a61), "Output should contain a-circumflex-acute (0x\(String(Viet.a61, radix: 16)))")
    }

    func testTelexCircumflexPlusAcute_ees() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x65)) // 'e'
        _ = engine.addKey(UniChar(0x65)) // 'e' -> circumflex
        let result = engine.addKey(UniChar(0x73)) // 's' -> acute
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.e61), "Output should contain e-circumflex-acute")
    }

    func testTelexCircumflexPlusAcute_oos() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x6F)) // 'o'
        _ = engine.addKey(UniChar(0x6F)) // 'o' -> circumflex
        let result = engine.addKey(UniChar(0x73)) // 's' -> acute
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.o61), "Output should contain o-circumflex-acute")
    }

    func testTelexHornPlusAcute_uws() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x75)) // 'u'
        _ = engine.addKey(UniChar(0x77)) // 'w' -> horn
        let result = engine.addKey(UniChar(0x73)) // 's' -> acute
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.u71), "Output should contain u-horn-acute")
    }

    func testTelexHornPlusHookAbove_owr() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x6F)) // 'o'
        _ = engine.addKey(UniChar(0x77)) // 'w' -> horn
        let result = engine.addKey(UniChar(0x72)) // 'r' -> hook above
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.o73), "Output should contain o-horn-hook-above")
    }

    // MARK: - Telex double-press revert

    func testTelexDoubleCircumflexReverts() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        _ = engine.addKey(UniChar(0x61)) // 'a' -> a-circumflex
        // At this point buffer has a-circumflex
        // Press 'a' again -> should revert (r2 != 0 path)
        let result = engine.addKey(UniChar(0x61)) // 'a' again
        // The revert should have happened (tempoff set, original restored)
        XCTAssertGreaterThanOrEqual(result, 0, "Third 'a' should trigger revert")
    }

    // MARK: - VNI tone marks

    func testVNIAcute_a1() {
        engine.inputMethod = .vni
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x31)) // '1'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a1), "VNI: a1 should produce a-acute")
    }

    func testVNIGrave_a2() {
        engine.inputMethod = .vni
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x32)) // '2'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a2), "VNI: a2 should produce a-grave")
    }

    func testVNIHookAbove_a3() {
        engine.inputMethod = .vni
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x33)) // '3'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a3), "VNI: a3 should produce a-hook-above")
    }

    func testVNITilde_a4() {
        engine.inputMethod = .vni
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x34)) // '4'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a4), "VNI: a4 should produce a-tilde")
    }

    func testVNIDotBelow_a5() {
        engine.inputMethod = .vni
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x35)) // '5'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a5), "VNI: a5 should produce a-dot-below")
    }

    func testVNICircumflex_a6() {
        engine.inputMethod = .vni
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x36)) // '6'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a6), "VNI: a6 should produce a-circumflex")
    }

    func testVNICircumflex_e6() {
        engine.inputMethod = .vni
        _ = engine.addKey(UniChar(0x65)) // 'e'
        let result = engine.addKey(UniChar(0x36)) // '6'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.e6), "VNI: e6 should produce e-circumflex")
    }

    func testVNICircumflex_o6() {
        engine.inputMethod = .vni
        _ = engine.addKey(UniChar(0x6F)) // 'o'
        let result = engine.addKey(UniChar(0x36)) // '6'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.o6), "VNI: o6 should produce o-circumflex")
    }

    func testVNIHorn_o7() {
        engine.inputMethod = .vni
        _ = engine.addKey(UniChar(0x6F)) // 'o'
        let result = engine.addKey(UniChar(0x37)) // '7'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.o7), "VNI: o7 should produce o-horn")
    }

    func testVNIHorn_u7() {
        engine.inputMethod = .vni
        _ = engine.addKey(UniChar(0x75)) // 'u'
        let result = engine.addKey(UniChar(0x37)) // '7'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.u7), "VNI: u7 should produce u-horn")
    }

    func testVNIBreve_a8() {
        engine.inputMethod = .vni
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x38)) // '8'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a8), "VNI: a8 should produce a-breve")
    }

    func testVNIDBar_d9() {
        engine.inputMethod = .vni
        _ = engine.addKey(UniChar(0x64)) // 'd'
        let result = engine.addKey(UniChar(0x39)) // '9'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.d9), "VNI: d9 should produce d-bar")
    }

    // MARK: - Space bar resets buffer

    func testSpaceBarClearsBuffer() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        _ = engine.addKey(KeyCode.spaceBar)
        // After space, buffer should be cleared
        // Adding another key starts fresh
        _ = engine.addKey(UniChar(0x61)) // 'a'
        _ = engine.addKey(UniChar(0x73)) // 's'
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a1), "After space + 'as', should produce a-acute")
    }

    // MARK: - addKey return values

    func testAddKeyReturnsNegativeOneForFirstChar() {
        engine.inputMethod = .telex
        let result = engine.addKey(UniChar(0x61)) // 'a'
        XCTAssertEqual(result, -1, "First character should return -1 (no modification)")
    }

    func testAddKeyReturnsPositionForModification() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x73)) // 's' -> acute
        XCTAssertGreaterThanOrEqual(result, 0, "Modifier key should return position >= 0")
    }

    func testAddKeyReturnsNegativeOneForNonModifier() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x62)) // 'b' (consonant)
        let result = engine.addKey(UniChar(0x63)) // 'c' (another consonant)
        XCTAssertEqual(result, -1, "Non-modifier after consonant should return -1")
    }

    // MARK: - isValidModifier

    func testIsValidModifierForTelexVowel() {
        engine.inputMethod = .telex
        // 's' should be a valid modifier for 'a' (0x61) in Telex mode
        let valid = engine.isValidModifier(Viet.a, key: CChar(0x73)) // 's'
        XCTAssertTrue(valid, "'s' should be valid Telex modifier for 'a'")
    }

    func testIsValidModifierForVNIVowel() {
        engine.inputMethod = .vni
        // '1' should be a valid modifier for 'a' (0x61) in VNI mode
        let valid = engine.isValidModifier(Viet.a, key: CChar(0x31)) // '1'
        XCTAssertTrue(valid, "'1' should be valid VNI modifier for 'a'")
    }

    func testIsValidModifierReturnsFalseForOff() {
        engine.inputMethod = .off
        let valid = engine.isValidModifier(Viet.a, key: CChar(0x73))
        XCTAssertFalse(valid, "Off mode should always return false")
    }

    func testIsValidModifierReturnsFalseForNonModifierKey() {
        engine.inputMethod = .telex
        // 'b' is not a Telex modifier key
        let valid = engine.isValidModifier(Viet.a, key: CChar(0x62))
        XCTAssertFalse(valid, "'b' should not be a valid Telex modifier")
    }

    func testIsValidModifierForDBar() {
        engine.inputMethod = .telex
        // 'd' should be valid modifier for 'd' character
        let valid = engine.isValidModifier(Viet.d, key: CChar(0x64)) // 'd'
        XCTAssertTrue(valid, "'d' should be valid Telex modifier for 'd'")
    }

    // MARK: - Thread-safe wrappers

    func testAddKeyThreadSafe() {
        engine.inputMethod = .telex
        let result = engine.addKeyThreadSafe(UniChar(0x61))
        XCTAssertEqual(result, -1)
    }

    func testClearBufferThreadSafe() {
        engine.inputMethod = .telex
        _ = engine.addKeyThreadSafe(UniChar(0x61))
        engine.clearBufferThreadSafe()
        XCTAssertEqual(engine.kbBLength, 0)
    }

    // MARK: - getOutputSlice

    func testGetOutputSliceInitiallyEmpty() {
        let output = engine.getOutputSlice()
        XCTAssertEqual(output.outputLength, 0)
        XCTAssertEqual(output.backspaceCount, 0)
    }

    func testGetOutputSliceAfterModification() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        _ = engine.addKey(UniChar(0x73)) // 's' -> modify
        let output = engine.getOutputSlice()
        XCTAssertGreaterThan(output.outputLength, 0, "Should have output after modification")
        XCTAssertGreaterThan(output.backspaceCount, 0, "Should have backspaces to replace previous char")
    }

    // MARK: - Uppercase Telex

    func testTelexUppercaseAcute_AS() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x41)) // 'A'
        let result = engine.addKey(UniChar(0x53)) // 'S'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.A1), "Uppercase 'AS' should produce A-acute")
    }

    func testTelexUppercaseDBar_DD() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x44)) // 'D'
        let result = engine.addKey(UniChar(0x44)) // 'D'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.D9), "Uppercase 'DD' should produce D-bar")
    }

    // MARK: - VowelsMap structure

    func testVowelsMapHasSevenGroups() {
        XCTAssertEqual(engine.vowelsMap.count, 7, "vowelsMap should have 7 groups: a, e, i, o, u, y, d")
    }

    func testVowelsMapAGroupSize() {
        // a group: a, a1-a5, a6, a61-a65, a8, a81-a85 (lower) + same upper = 36
        XCTAssertEqual(engine.vowelsMap[0].count, 36)
    }

    func testVowelsMapEGroupSize() {
        // e group: e, e1-e5, e6, e61-e65 (lower) + same upper = 24
        XCTAssertEqual(engine.vowelsMap[1].count, 24)
    }

    func testVowelsMapIGroupSize() {
        // i group: i, i1-i5 (lower) + same upper = 12
        XCTAssertEqual(engine.vowelsMap[2].count, 12)
    }

    func testVowelsMapOGroupSize() {
        // o group: o, o1-o5, o6, o61-o65, o7, o71-o75 (lower) + same upper = 36
        XCTAssertEqual(engine.vowelsMap[3].count, 36)
    }

    func testVowelsMapUGroupSize() {
        // u group: u, u1-u5, u7, u71-u75 (lower) + same upper = 24
        XCTAssertEqual(engine.vowelsMap[4].count, 24)
    }

    func testVowelsMapYGroupSize() {
        // y group: y, y1-y5 (lower) + same upper = 12
        XCTAssertEqual(engine.vowelsMap[5].count, 12)
    }

    func testVowelsMapDGroupSize() {
        // d group: d, D, d9, D9, vnd = 5
        XCTAssertEqual(engine.vowelsMap[6].count, 5)
    }

    // MARK: - E vowel Telex tests

    func testTelexEAcute_es() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x65)) // 'e'
        let result = engine.addKey(UniChar(0x73)) // 's'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.e1), "Telex 'es' should produce e-acute")
    }

    // MARK: - O vowel Telex tests

    func testTelexOAcute_os() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x6F)) // 'o'
        let result = engine.addKey(UniChar(0x73)) // 's'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.o1), "Telex 'os' should produce o-acute")
    }

    // MARK: - U vowel Telex tests

    func testTelexUAcute_us() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x75)) // 'u'
        let result = engine.addKey(UniChar(0x73)) // 's'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.u1), "Telex 'us' should produce u-acute")
    }

    // MARK: - I vowel Telex tests

    func testTelexIAcute_is() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x69)) // 'i'
        let result = engine.addKey(UniChar(0x73)) // 's'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.i1), "Telex 'is' should produce i-acute")
    }

    // MARK: - Y vowel Telex tests

    func testTelexYAcute_ys() {
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x79)) // 'y'
        let result = engine.addKey(UniChar(0x73)) // 's'
        XCTAssertGreaterThanOrEqual(result, 0)
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength)).filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.y1), "Telex 'ys' should produce y-acute")
    }
}
