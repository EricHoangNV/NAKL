import XCTest
@testable import NAKL

final class TelexTests: XCTestCase {

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

    /// Feed a string of ASCII keystrokes into the engine (clearing buffer first)
    /// and return the raw UInt16 output (non-backspace portion) from the last
    /// modification's output slice.
    private func typeKeysRaw(_ keys: String) -> [UInt16] {
        engine.clearBuffer()
        engine.inputMethod = .telex
        for scalar in keys.unicodeScalars {
            _ = engine.addKey(UniChar(scalar.value))
        }
        let output = engine.getOutputSlice()
        if output.outputLength == 0 { return [] }
        return Array(output.pointer.suffix(output.outputLength).prefix(while: { $0 != 0 }))
    }

    /// Feed keys and return the full output as a Unicode string (non-backspace chars only).
    private func typeKeys(_ keys: String) -> String {
        engine.clearBuffer()
        engine.inputMethod = .telex
        for scalar in keys.unicodeScalars {
            _ = engine.addKey(UniChar(scalar.value))
        }
        let output = engine.getOutputSlice()
        if output.outputLength == 0 && output.backspaceCount == 0 { return "" }
        let chars = output.pointer.prefix(output.backspaceCount + output.outputLength)
        return String(
            chars.compactMap { code -> Character? in
                guard code != 0x08, code != 0 else { return nil }
                return Character(UnicodeScalar(UInt32(code))!)
            }
        )
    }

    /// Assert that the raw output of typing `keys` contains the expected UInt16 code.
    private func assertOutputContains(_ keys: String, expected: UInt16, _ message: String,
                                      file: StaticString = #filePath, line: UInt = #line) {
        engine.clearBuffer()
        engine.inputMethod = .telex
        var lastResult = -1
        for scalar in keys.unicodeScalars {
            lastResult = engine.addKey(UniChar(scalar.value))
        }
        let output = engine.getOutputSlice()
        let all = Array(output.pointer.prefix(output.backspaceCount + output.outputLength))
        let nonBackspace = all.filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(expected),
                      "\(message) — expected 0x\(String(expected, radix: 16)) in \(nonBackspace.map { String(format: "0x%04X", $0) })",
                      file: file, line: line)
    }

    // MARK: - 1. TelexRules array sizes

    func testCodeAUppercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_A.count, 36, "code_A should have 36 entries")
    }

    func testCodeALowercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_a.count, 36, "code_a should have 36 entries")
    }

    func testCodeEUppercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_E.count, 24, "code_E should have 24 entries")
    }

    func testCodeELowercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_e.count, 24, "code_e should have 24 entries")
    }

    func testCodeOUppercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_O.count, 36, "code_O should have 36 entries")
    }

    func testCodeOLowercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_o.count, 36, "code_o should have 36 entries")
    }

    func testCodeWUppercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_W.count, 96, "code_W should have 96 entries (a+o+u groups)")
    }

    func testCodeWLowercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_w.count, 96, "code_w should have 96 entries (a+o+u groups)")
    }

    func testCodeDUppercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_D.count, 4, "code_D should have 4 entries")
    }

    func testCodeDLowercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_d.count, 4, "code_d should have 4 entries")
    }

    func testCodeSUppercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_S.count, 144, "code_S should have 144 entries")
    }

    func testCodeSLowercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_s.count, 144, "code_s should have 144 entries")
    }

    func testCodeFUppercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_F.count, 144, "code_F should have 144 entries")
    }

    func testCodeFLowercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_f.count, 144, "code_f should have 144 entries")
    }

    func testCodeRUppercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_R.count, 144, "code_R should have 144 entries")
    }

    func testCodeRLowercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_r.count, 144, "code_r should have 144 entries")
    }

    func testCodeXUppercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_X.count, 144, "code_X should have 144 entries")
    }

    func testCodeXLowercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_x.count, 144, "code_x should have 144 entries")
    }

    func testCodeJUppercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_J.count, 144, "code_J should have 144 entries")
    }

    func testCodeJLowercaseArrayCount() {
        XCTAssertEqual(TelexRules.code_j.count, 144, "code_j should have 144 entries")
    }

    // MARK: - 1b. All arrays are non-empty

    func testAllTelexRulesArraysNonEmpty() {
        let arrays: [(String, [VietCode])] = [
            ("code_A", TelexRules.code_A), ("code_a", TelexRules.code_a),
            ("code_E", TelexRules.code_E), ("code_e", TelexRules.code_e),
            ("code_O", TelexRules.code_O), ("code_o", TelexRules.code_o),
            ("code_W", TelexRules.code_W), ("code_w", TelexRules.code_w),
            ("code_D", TelexRules.code_D), ("code_d", TelexRules.code_d),
            ("code_S", TelexRules.code_S), ("code_s", TelexRules.code_s),
            ("code_F", TelexRules.code_F), ("code_f", TelexRules.code_f),
            ("code_R", TelexRules.code_R), ("code_r", TelexRules.code_r),
            ("code_X", TelexRules.code_X), ("code_x", TelexRules.code_x),
            ("code_J", TelexRules.code_J), ("code_j", TelexRules.code_j),
        ]
        for (name, arr) in arrays {
            XCTAssertFalse(arr.isEmpty, "\(name) must not be empty")
        }
    }

    // MARK: - 2. VietCode structure validation

    func testVietCodeFieldsAreNonZeroForFirstEntry() {
        let entry = TelexRules.code_s[0]
        XCTAssertNotEqual(entry.c, 0, "c field should be nonzero")
        XCTAssertNotEqual(entry.r1, 0, "r1 field should be nonzero")
    }

    func testVietCodeRevertFieldForCircumflexDoublePress() {
        // code_a: entry for a6 (circumflex) should have r2 != 0 (revert)
        let revertEntries = TelexRules.code_a.filter { $0.c == Viet.a6 }
        XCTAssertEqual(revertEntries.count, 1)
        XCTAssertNotEqual(revertEntries[0].r2, 0, "a6 entry in code_a should have r2 (revert char)")
        XCTAssertEqual(revertEntries[0].r1, Viet.a, "a6 + a should revert to plain a")
    }

    func testVietCodeRevertFieldForDStrokeDoublePress() {
        let revertEntries = TelexRules.code_d.filter { $0.c == Viet.d9 }
        XCTAssertEqual(revertEntries.count, 1)
        XCTAssertNotEqual(revertEntries[0].r2, 0, "d9 entry in code_d should have r2 (revert)")
        XCTAssertEqual(revertEntries[0].r1, Viet.d, "d9 + d should revert to plain d")
    }

    // MARK: - 3. Tone mark tests: acute (s)

    func testTelexAcute_as() {
        assertOutputContains("as", expected: Viet.a1, "as -> a-acute")
    }

    func testTelexAcute_es() {
        assertOutputContains("es", expected: Viet.e1, "es -> e-acute")
    }

    func testTelexAcute_is() {
        assertOutputContains("is", expected: Viet.i1, "is -> i-acute")
    }

    func testTelexAcute_os() {
        assertOutputContains("os", expected: Viet.o1, "os -> o-acute")
    }

    func testTelexAcute_us() {
        assertOutputContains("us", expected: Viet.u1, "us -> u-acute")
    }

    func testTelexAcute_ys() {
        assertOutputContains("ys", expected: Viet.y1, "ys -> y-acute")
    }

    // MARK: - 4. Tone mark tests: grave (f)

    func testTelexGrave_af() {
        assertOutputContains("af", expected: Viet.a2, "af -> a-grave")
    }

    func testTelexGrave_ef() {
        assertOutputContains("ef", expected: Viet.e2, "ef -> e-grave")
    }

    func testTelexGrave_if() {
        assertOutputContains("if", expected: Viet.i2, "if -> i-grave")
    }

    func testTelexGrave_of() {
        assertOutputContains("of", expected: Viet.o2, "of -> o-grave")
    }

    func testTelexGrave_uf() {
        assertOutputContains("uf", expected: Viet.u2, "uf -> u-grave")
    }

    func testTelexGrave_yf() {
        assertOutputContains("yf", expected: Viet.y2, "yf -> y-grave")
    }

    // MARK: - 5. Tone mark tests: hook above (r)

    func testTelexHookAbove_ar() {
        assertOutputContains("ar", expected: Viet.a3, "ar -> a-hook-above")
    }

    func testTelexHookAbove_er() {
        assertOutputContains("er", expected: Viet.e3, "er -> e-hook-above")
    }

    func testTelexHookAbove_ir() {
        assertOutputContains("ir", expected: Viet.i3, "ir -> i-hook-above")
    }

    func testTelexHookAbove_or() {
        assertOutputContains("or", expected: Viet.o3, "or -> o-hook-above")
    }

    func testTelexHookAbove_ur() {
        assertOutputContains("ur", expected: Viet.u3, "ur -> u-hook-above")
    }

    func testTelexHookAbove_yr() {
        assertOutputContains("yr", expected: Viet.y3, "yr -> y-hook-above")
    }

    // MARK: - 6. Tone mark tests: tilde (x)

    func testTelexTilde_ax() {
        assertOutputContains("ax", expected: Viet.a4, "ax -> a-tilde")
    }

    func testTelexTilde_ex() {
        assertOutputContains("ex", expected: Viet.e4, "ex -> e-tilde")
    }

    func testTelexTilde_ix() {
        assertOutputContains("ix", expected: Viet.i4, "ix -> i-tilde")
    }

    func testTelexTilde_ox() {
        assertOutputContains("ox", expected: Viet.o4, "ox -> o-tilde")
    }

    func testTelexTilde_ux() {
        assertOutputContains("ux", expected: Viet.u4, "ux -> u-tilde")
    }

    func testTelexTilde_yx() {
        assertOutputContains("yx", expected: Viet.y4, "yx -> y-tilde")
    }

    // MARK: - 7. Tone mark tests: dot below (j)

    func testTelexDotBelow_aj() {
        assertOutputContains("aj", expected: Viet.a5, "aj -> a-dot-below")
    }

    func testTelexDotBelow_ej() {
        assertOutputContains("ej", expected: Viet.e5, "ej -> e-dot-below")
    }

    func testTelexDotBelow_ij() {
        assertOutputContains("ij", expected: Viet.i5, "ij -> i-dot-below")
    }

    func testTelexDotBelow_oj() {
        assertOutputContains("oj", expected: Viet.o5, "oj -> o-dot-below")
    }

    func testTelexDotBelow_uj() {
        assertOutputContains("uj", expected: Viet.u5, "uj -> u-dot-below")
    }

    func testTelexDotBelow_yj() {
        assertOutputContains("yj", expected: Viet.y5, "yj -> y-dot-below")
    }

    // MARK: - 8. Circumflex tests (aa, ee, oo)

    func testTelexCircumflex_aa() {
        assertOutputContains("aa", expected: Viet.a6, "aa -> a-circumflex")
    }

    func testTelexCircumflex_ee() {
        assertOutputContains("ee", expected: Viet.e6, "ee -> e-circumflex")
    }

    func testTelexCircumflex_oo() {
        assertOutputContains("oo", expected: Viet.o6, "oo -> o-circumflex")
    }

    // MARK: - 9. Circumflex + tone combinations

    func testTelexCircumflexAcute_aas() {
        assertOutputContains("aas", expected: Viet.a61, "aas -> a-circumflex-acute")
    }

    func testTelexCircumflexGrave_aaf() {
        assertOutputContains("aaf", expected: Viet.a62, "aaf -> a-circumflex-grave")
    }

    func testTelexCircumflexHook_aar() {
        assertOutputContains("aar", expected: Viet.a63, "aar -> a-circumflex-hook")
    }

    func testTelexCircumflexTilde_aax() {
        assertOutputContains("aax", expected: Viet.a64, "aax -> a-circumflex-tilde")
    }

    func testTelexCircumflexDot_aaj() {
        assertOutputContains("aaj", expected: Viet.a65, "aaj -> a-circumflex-dot")
    }

    func testTelexCircumflexAcute_ees() {
        assertOutputContains("ees", expected: Viet.e61, "ees -> e-circumflex-acute")
    }

    func testTelexCircumflexGrave_eef() {
        assertOutputContains("eef", expected: Viet.e62, "eef -> e-circumflex-grave")
    }

    func testTelexCircumflexHook_eer() {
        assertOutputContains("eer", expected: Viet.e63, "eer -> e-circumflex-hook")
    }

    func testTelexCircumflexTilde_eex() {
        assertOutputContains("eex", expected: Viet.e64, "eex -> e-circumflex-tilde")
    }

    func testTelexCircumflexDot_eej() {
        assertOutputContains("eej", expected: Viet.e65, "eej -> e-circumflex-dot")
    }

    func testTelexCircumflexAcute_oos() {
        assertOutputContains("oos", expected: Viet.o61, "oos -> o-circumflex-acute")
    }

    func testTelexCircumflexGrave_oof() {
        assertOutputContains("oof", expected: Viet.o62, "oof -> o-circumflex-grave")
    }

    func testTelexCircumflexHook_oor() {
        assertOutputContains("oor", expected: Viet.o63, "oor -> o-circumflex-hook")
    }

    func testTelexCircumflexTilde_oox() {
        assertOutputContains("oox", expected: Viet.o64, "oox -> o-circumflex-tilde")
    }

    func testTelexCircumflexDot_ooj() {
        assertOutputContains("ooj", expected: Viet.o65, "ooj -> o-circumflex-dot")
    }

    // MARK: - 10. Breve/horn via w

    func testTelexBreve_aw() {
        assertOutputContains("aw", expected: Viet.a8, "aw -> a-breve")
    }

    func testTelexHorn_ow() {
        assertOutputContains("ow", expected: Viet.o7, "ow -> o-horn")
    }

    func testTelexHorn_uw() {
        assertOutputContains("uw", expected: Viet.u7, "uw -> u-horn")
    }

    // MARK: - 11. Breve + tone combinations

    func testTelexBreveAcute_aws() {
        assertOutputContains("aws", expected: Viet.a81, "aws -> a-breve-acute")
    }

    func testTelexBreveGrave_awf() {
        assertOutputContains("awf", expected: Viet.a82, "awf -> a-breve-grave")
    }

    func testTelexBreveHook_awr() {
        assertOutputContains("awr", expected: Viet.a83, "awr -> a-breve-hook")
    }

    func testTelexBreveTilde_awx() {
        assertOutputContains("awx", expected: Viet.a84, "awx -> a-breve-tilde")
    }

    func testTelexBreveDot_awj() {
        assertOutputContains("awj", expected: Viet.a85, "awj -> a-breve-dot")
    }

    // MARK: - 12. Horn + tone combinations (o-horn)

    func testTelexHornAcute_ows() {
        assertOutputContains("ows", expected: Viet.o71, "ows -> o-horn-acute")
    }

    func testTelexHornGrave_owf() {
        assertOutputContains("owf", expected: Viet.o72, "owf -> o-horn-grave")
    }

    func testTelexHornHook_owr() {
        assertOutputContains("owr", expected: Viet.o73, "owr -> o-horn-hook")
    }

    func testTelexHornTilde_owx() {
        assertOutputContains("owx", expected: Viet.o74, "owx -> o-horn-tilde")
    }

    func testTelexHornDot_owj() {
        assertOutputContains("owj", expected: Viet.o75, "owj -> o-horn-dot")
    }

    // MARK: - 13. Horn + tone combinations (u-horn)

    func testTelexHornAcute_uws() {
        assertOutputContains("uws", expected: Viet.u71, "uws -> u-horn-acute")
    }

    func testTelexHornGrave_uwf() {
        assertOutputContains("uwf", expected: Viet.u72, "uwf -> u-horn-grave")
    }

    func testTelexHornHook_uwr() {
        assertOutputContains("uwr", expected: Viet.u73, "uwr -> u-horn-hook")
    }

    func testTelexHornTilde_uwx() {
        assertOutputContains("uwx", expected: Viet.u74, "uwx -> u-horn-tilde")
    }

    func testTelexHornDot_uwj() {
        assertOutputContains("uwj", expected: Viet.u75, "uwj -> u-horn-dot")
    }

    // MARK: - 14. D-stroke

    func testTelexDStroke_dd() {
        assertOutputContains("dd", expected: Viet.d9, "dd -> d-stroke")
    }

    func testTelexDStrokeUppercase_DD() {
        assertOutputContains("DD", expected: Viet.D9, "DD -> D-stroke (uppercase)")
    }

    // MARK: - 15. Double-press revert for circumflex

    func testTelexCircumflexRevert_aaa() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // a
        _ = engine.addKey(UniChar(0x61)) // a -> circumflex
        let result = engine.addKey(UniChar(0x61)) // a -> revert
        XCTAssertGreaterThanOrEqual(result, 0, "Third 'a' should trigger revert")
    }

    func testTelexCircumflexRevert_eee() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x65)) // e
        _ = engine.addKey(UniChar(0x65)) // e -> circumflex
        let result = engine.addKey(UniChar(0x65)) // e -> revert
        XCTAssertGreaterThanOrEqual(result, 0, "Third 'e' should trigger revert")
    }

    func testTelexCircumflexRevert_ooo() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x6F)) // o
        _ = engine.addKey(UniChar(0x6F)) // o -> circumflex
        let result = engine.addKey(UniChar(0x6F)) // o -> revert
        XCTAssertGreaterThanOrEqual(result, 0, "Third 'o' should trigger revert")
    }

    // MARK: - 16. Double-press revert for d-stroke

    func testTelexDStrokeRevert_ddd() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x64)) // d
        _ = engine.addKey(UniChar(0x64)) // d -> d-stroke
        let result = engine.addKey(UniChar(0x64)) // d -> revert
        XCTAssertGreaterThanOrEqual(result, 0, "Third 'd' should trigger revert")
    }

    // MARK: - 17. Double-press revert for breve/horn

    func testTelexBreveRevert_aww() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // a
        _ = engine.addKey(UniChar(0x77)) // w -> breve
        let result = engine.addKey(UniChar(0x77)) // w -> revert
        XCTAssertGreaterThanOrEqual(result, 0, "Second 'w' after aw should trigger revert")
    }

    func testTelexHornRevert_oww() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x6F)) // o
        _ = engine.addKey(UniChar(0x77)) // w -> horn
        let result = engine.addKey(UniChar(0x77)) // w -> revert
        XCTAssertGreaterThanOrEqual(result, 0, "Second 'w' after ow should trigger revert")
    }

    func testTelexHornRevert_uww() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x75)) // u
        _ = engine.addKey(UniChar(0x77)) // w -> horn
        let result = engine.addKey(UniChar(0x77)) // w -> revert
        XCTAssertGreaterThanOrEqual(result, 0, "Second 'w' after uw should trigger revert")
    }

    // MARK: - 18. Uppercase tone marks

    func testTelexUppercaseAcute_As() {
        assertOutputContains("As", expected: Viet.A1, "As -> A-acute")
    }

    func testTelexUppercaseGrave_Af() {
        assertOutputContains("Af", expected: Viet.A2, "Af -> A-grave")
    }

    func testTelexUppercaseHook_Ar() {
        assertOutputContains("Ar", expected: Viet.A3, "Ar -> A-hook-above")
    }

    func testTelexUppercaseTilde_Ax() {
        assertOutputContains("Ax", expected: Viet.A4, "Ax -> A-tilde")
    }

    func testTelexUppercaseDot_Aj() {
        assertOutputContains("Aj", expected: Viet.A5, "Aj -> A-dot-below")
    }

    func testTelexUppercaseCircumflex_AA() {
        assertOutputContains("AA", expected: Viet.A6, "AA -> A-circumflex")
    }

    func testTelexUppercaseBreve_Aw() {
        assertOutputContains("Aw", expected: Viet.A8, "Aw -> A-breve")
    }

    func testTelexUppercaseECircumflex_EE() {
        assertOutputContains("EE", expected: Viet.E6, "EE -> E-circumflex")
    }

    func testTelexUppercaseOCircumflex_OO() {
        assertOutputContains("OO", expected: Viet.O6, "OO -> O-circumflex")
    }

    func testTelexUppercaseOHorn_Ow() {
        assertOutputContains("Ow", expected: Viet.O7, "Ow -> O-horn")
    }

    func testTelexUppercaseUHorn_Uw() {
        assertOutputContains("Uw", expected: Viet.U7, "Uw -> U-horn")
    }

    // MARK: - 19. Uppercase circumflex + tone

    func testTelexUppercaseCircumflexAcute_AAs() {
        assertOutputContains("AAs", expected: Viet.A61, "AAs -> A-circumflex-acute")
    }

    func testTelexUppercaseCircumflexGrave_AAf() {
        assertOutputContains("AAf", expected: Viet.A62, "AAf -> A-circumflex-grave")
    }

    func testTelexUppercaseCircumflexDot_AAj() {
        assertOutputContains("AAj", expected: Viet.A65, "AAj -> A-circumflex-dot")
    }

    func testTelexUppercaseECircumflexAcute_EEs() {
        assertOutputContains("EEs", expected: Viet.E61, "EEs -> E-circumflex-acute")
    }

    func testTelexUppercaseOCircumflexAcute_OOs() {
        assertOutputContains("OOs", expected: Viet.O61, "OOs -> O-circumflex-acute")
    }

    // MARK: - 20. Uppercase breve/horn + tone

    func testTelexUppercaseBreveAcute_Aws() {
        assertOutputContains("Aws", expected: Viet.A81, "Aws -> A-breve-acute")
    }

    func testTelexUppercaseHornAcute_Ows() {
        assertOutputContains("Ows", expected: Viet.O71, "Ows -> O-horn-acute")
    }

    func testTelexUppercaseHornAcute_Uws() {
        assertOutputContains("Uws", expected: Viet.U71, "Uws -> U-horn-acute")
    }

    // MARK: - 21. Tone replacement (switching tones)

    func testTelexToneReplace_asf_acuteToGrave() {
        // type a, s (acute), then f (should switch to grave)
        assertOutputContains("asf", expected: Viet.a2, "asf -> tone switches from acute to grave")
    }

    func testTelexToneReplace_afr_graveToHook() {
        assertOutputContains("afr", expected: Viet.a3, "afr -> tone switches from grave to hook")
    }

    func testTelexToneReplace_arx_hookToTilde() {
        assertOutputContains("arx", expected: Viet.a4, "arx -> tone switches from hook to tilde")
    }

    func testTelexToneReplace_axj_tildeToDoc() {
        assertOutputContains("axj", expected: Viet.a5, "axj -> tone switches from tilde to dot")
    }

    // MARK: - 22. Tone on circumflex vowels (tone replacement)

    func testTelexCircumflexToneSwitch_aasf() {
        assertOutputContains("aasf", expected: Viet.a62, "aasf -> circumflex-acute switches to circumflex-grave")
    }

    func testTelexCircumflexToneSwitch_eesr() {
        assertOutputContains("eesr", expected: Viet.e63, "eesr -> circumflex-acute switches to circumflex-hook")
    }

    // MARK: - 23. Tone on breve vowels (tone replacement)

    func testTelexBreveToneSwitch_awsf() {
        assertOutputContains("awsf", expected: Viet.a82, "awsf -> breve-acute switches to breve-grave")
    }

    // MARK: - 24. Tone on horn vowels (tone replacement)

    func testTelexHornToneSwitch_owsf() {
        assertOutputContains("owsf", expected: Viet.o72, "owsf -> horn-acute switches to horn-grave")
    }

    func testTelexHornToneSwitch_uwsf() {
        assertOutputContains("uwsf", expected: Viet.u72, "uwsf -> horn-acute switches to horn-grave")
    }

    // MARK: - 25. Double-press tone revert

    func testTelexAcuteDoubleRevert_ass() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // a
        _ = engine.addKey(UniChar(0x73)) // s -> acute
        let result = engine.addKey(UniChar(0x73)) // s -> revert
        XCTAssertGreaterThanOrEqual(result, 0, "Double 's' should revert the acute tone")
    }

    func testTelexGraveDoubleRevert_aff() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // a
        _ = engine.addKey(UniChar(0x66)) // f -> grave
        let result = engine.addKey(UniChar(0x66)) // f -> revert
        XCTAssertGreaterThanOrEqual(result, 0, "Double 'f' should revert the grave tone")
    }

    // MARK: - 26. Engine clearBuffer between words

    func testClearBufferResetsForNewWord() {
        assertOutputContains("as", expected: Viet.a1, "First word: as -> a-acute")
        engine.clearBuffer()
        assertOutputContains("ef", expected: Viet.e2, "Second word after clear: ef -> e-grave")
    }

    // MARK: - 27. addKey return values

    func testAddKeyReturnsNegativeOneForPlainChar() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        let result = engine.addKey(UniChar(0x61)) // 'a'
        XCTAssertEqual(result, -1, "First char should return -1")
    }

    func testAddKeyReturnsPositionForModifier() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // 'a'
        let result = engine.addKey(UniChar(0x73)) // 's'
        XCTAssertGreaterThanOrEqual(result, 0, "Modifier 's' should return position >= 0")
    }

    func testAddKeyReturnsNegativeOneForConsonantPair() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x62)) // 'b'
        let result = engine.addKey(UniChar(0x63)) // 'c'
        XCTAssertEqual(result, -1, "Non-modifier consonant should return -1")
    }

    // MARK: - 28. Circumflex from breve base (code_A: a8 -> a6)

    func testTelexCircumflexFromBreve_code_a_breve_to_circumflex() {
        // Verify that code_a maps a8 (breve) -> a6 (circumflex)
        let entry = TelexRules.code_a.first(where: { $0.c == Viet.a8 })
        XCTAssertNotNil(entry, "code_a should have entry for a8")
        XCTAssertEqual(entry?.r1, Viet.a6, "a8 + a should become a6 (circumflex replaces breve)")
    }

    func testTelexCircumflexFromBreveToned_code_a_breve_acute_to_circumflex_acute() {
        let entry = TelexRules.code_a.first(where: { $0.c == Viet.a81 })
        XCTAssertNotNil(entry, "code_a should have entry for a81")
        XCTAssertEqual(entry?.r1, Viet.a61, "a81 + a should become a61")
    }

    // MARK: - 29. Horn from circumflex base (code_w: o6 -> o7)

    func testTelexHornFromCircumflex_code_w_o6_to_o7() {
        let entry = TelexRules.code_w.first(where: { $0.c == Viet.o6 })
        XCTAssertNotNil(entry, "code_w should have entry for o6")
        XCTAssertEqual(entry?.r1, Viet.o7, "o6 + w should become o7 (horn replaces circumflex)")
    }

    func testTelexBreveFromCircumflex_code_w_a6_to_a8() {
        let entry = TelexRules.code_w.first(where: { $0.c == Viet.a6 })
        XCTAssertNotNil(entry, "code_w should have entry for a6")
        XCTAssertEqual(entry?.r1, Viet.a8, "a6 + w should become a8 (breve replaces circumflex)")
    }

    // MARK: - 30. Circumflex from horn base (code_o: o7 -> o6)

    func testTelexCircumflexFromHorn_code_o_o7_to_o6() {
        let entry = TelexRules.code_o.first(where: { $0.c == Viet.o7 })
        XCTAssertNotNil(entry, "code_o should have entry for o7")
        XCTAssertEqual(entry?.r1, Viet.o6, "o7 + o should become o6 (circumflex replaces horn)")
    }

    // MARK: - 31. Tone arrays cover all vowel groups

    func testCodeSCoversAllBaseVowels() {
        let matchChars = Set(TelexRules.code_s.map { $0.c })
        let expectedBases: [UInt16] = [
            Viet.a, Viet.A, Viet.e, Viet.E, Viet.i, Viet.I,
            Viet.o, Viet.O, Viet.u, Viet.U, Viet.y, Viet.Y,
        ]
        for base in expectedBases {
            XCTAssertTrue(matchChars.contains(base),
                          "code_s should have entry matching 0x\(String(base, radix: 16))")
        }
    }

    func testCodeSCoversCircumflexVowels() {
        let matchChars = Set(TelexRules.code_s.map { $0.c })
        let circumflexBases: [UInt16] = [
            Viet.a6, Viet.A6, Viet.e6, Viet.E6, Viet.o6, Viet.O6,
        ]
        for base in circumflexBases {
            XCTAssertTrue(matchChars.contains(base),
                          "code_s should have entry matching circumflex 0x\(String(base, radix: 16))")
        }
    }

    func testCodeSCoversBreviatedAndHornVowels() {
        let matchChars = Set(TelexRules.code_s.map { $0.c })
        let extraBases: [UInt16] = [
            Viet.a8, Viet.A8, Viet.o7, Viet.O7, Viet.u7, Viet.U7,
        ]
        for base in extraBases {
            XCTAssertTrue(matchChars.contains(base),
                          "code_s should have entry matching 0x\(String(base, radix: 16))")
        }
    }

    // MARK: - 32. Tone arrays: f, r, x, j also cover all vowels

    func testCodeFCoversAllBaseVowels() {
        let matchChars = Set(TelexRules.code_f.map { $0.c })
        for base in [Viet.a, Viet.e, Viet.i, Viet.o, Viet.u, Viet.y] {
            XCTAssertTrue(matchChars.contains(base), "code_f should match 0x\(String(base, radix: 16))")
        }
    }

    func testCodeRCoversAllBaseVowels() {
        let matchChars = Set(TelexRules.code_r.map { $0.c })
        for base in [Viet.a, Viet.e, Viet.i, Viet.o, Viet.u, Viet.y] {
            XCTAssertTrue(matchChars.contains(base), "code_r should match 0x\(String(base, radix: 16))")
        }
    }

    func testCodeXCoversAllBaseVowels() {
        let matchChars = Set(TelexRules.code_x.map { $0.c })
        for base in [Viet.a, Viet.e, Viet.i, Viet.o, Viet.u, Viet.y] {
            XCTAssertTrue(matchChars.contains(base), "code_x should match 0x\(String(base, radix: 16))")
        }
    }

    func testCodeJCoversAllBaseVowels() {
        let matchChars = Set(TelexRules.code_j.map { $0.c })
        for base in [Viet.a, Viet.e, Viet.i, Viet.o, Viet.u, Viet.y] {
            XCTAssertTrue(matchChars.contains(base), "code_j should match 0x\(String(base, radix: 16))")
        }
    }

    // MARK: - 33. isValidModifier checks

    func testIsValidModifier_s_for_a() {
        engine.inputMethod = .telex
        XCTAssertTrue(engine.isValidModifier(Viet.a, key: CChar(0x73)), "'s' valid for 'a'")
    }

    func testIsValidModifier_f_for_e() {
        engine.inputMethod = .telex
        XCTAssertTrue(engine.isValidModifier(Viet.e, key: CChar(0x66)), "'f' valid for 'e'")
    }

    func testIsValidModifier_r_for_o() {
        engine.inputMethod = .telex
        XCTAssertTrue(engine.isValidModifier(Viet.o, key: CChar(0x72)), "'r' valid for 'o'")
    }

    func testIsValidModifier_x_for_u() {
        engine.inputMethod = .telex
        XCTAssertTrue(engine.isValidModifier(Viet.u, key: CChar(0x78)), "'x' valid for 'u'")
    }

    func testIsValidModifier_j_for_i() {
        engine.inputMethod = .telex
        XCTAssertTrue(engine.isValidModifier(Viet.i, key: CChar(0x6A)), "'j' valid for 'i'")
    }

    func testIsValidModifier_d_for_d() {
        engine.inputMethod = .telex
        XCTAssertTrue(engine.isValidModifier(Viet.d, key: CChar(0x64)), "'d' valid for 'd'")
    }

    func testIsValidModifier_w_for_a() {
        engine.inputMethod = .telex
        XCTAssertTrue(engine.isValidModifier(Viet.a, key: CChar(0x77)), "'w' valid for 'a'")
    }

    func testIsValidModifier_w_for_o() {
        engine.inputMethod = .telex
        XCTAssertTrue(engine.isValidModifier(Viet.o, key: CChar(0x77)), "'w' valid for 'o'")
    }

    func testIsValidModifier_w_for_u() {
        engine.inputMethod = .telex
        XCTAssertTrue(engine.isValidModifier(Viet.u, key: CChar(0x77)), "'w' valid for 'u'")
    }

    func testIsValidModifier_b_not_valid() {
        engine.inputMethod = .telex
        XCTAssertFalse(engine.isValidModifier(Viet.a, key: CChar(0x62)), "'b' not valid for 'a'")
    }

    // MARK: - 34. Symmetry: uppercase/lowercase arrays have same count

    func testCodeASymmetry() {
        XCTAssertEqual(TelexRules.code_A.count, TelexRules.code_a.count)
    }

    func testCodeESymmetry() {
        XCTAssertEqual(TelexRules.code_E.count, TelexRules.code_e.count)
    }

    func testCodeOSymmetry() {
        XCTAssertEqual(TelexRules.code_O.count, TelexRules.code_o.count)
    }

    func testCodeWSymmetry() {
        XCTAssertEqual(TelexRules.code_W.count, TelexRules.code_w.count)
    }

    func testCodeDSymmetry() {
        XCTAssertEqual(TelexRules.code_D.count, TelexRules.code_d.count)
    }

    func testCodeSSymmetry() {
        XCTAssertEqual(TelexRules.code_S.count, TelexRules.code_s.count)
    }

    func testCodeFSymmetry() {
        XCTAssertEqual(TelexRules.code_F.count, TelexRules.code_f.count)
    }

    func testCodeRSymmetry() {
        XCTAssertEqual(TelexRules.code_R.count, TelexRules.code_r.count)
    }

    func testCodeXSymmetry() {
        XCTAssertEqual(TelexRules.code_X.count, TelexRules.code_x.count)
    }

    func testCodeJSymmetry() {
        XCTAssertEqual(TelexRules.code_J.count, TelexRules.code_j.count)
    }

    // MARK: - 35. VietCode r2 revert values use correct modifier char

    func testCodeSRevertUsesCorrectModifier() {
        // In code_s, revert entries (where r2 != 0) should use Viet.s
        let revertEntries = TelexRules.code_s.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty, "code_s should have revert entries")
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.s,
                           "code_s revert char should be Viet.s (0x\(String(Viet.s, radix: 16)))")
        }
    }

    func testCodeFRevertUsesCorrectModifier() {
        let revertEntries = TelexRules.code_f.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.f)
        }
    }

    func testCodeRRevertUsesCorrectModifier() {
        let revertEntries = TelexRules.code_r.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.r)
        }
    }

    func testCodeXRevertUsesCorrectModifier() {
        let revertEntries = TelexRules.code_x.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.x)
        }
    }

    func testCodeJRevertUsesCorrectModifier() {
        let revertEntries = TelexRules.code_j.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.j)
        }
    }

    func testCodeWRevertUsesCorrectModifier() {
        let revertEntries = TelexRules.code_w.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.w)
        }
    }

    func testCodeDRevertUsesCorrectModifier() {
        let revertEntries = TelexRules.code_d.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.d)
        }
    }

    // MARK: - 36. No duplicate match chars in arrays (each c is unique)

    func testCodeSNoDuplicateMatchChars() {
        let chars = TelexRules.code_s.map { $0.c }
        XCTAssertEqual(chars.count, Set(chars).count, "code_s should have no duplicate c values")
    }

    func testCodeFNoDuplicateMatchChars() {
        let chars = TelexRules.code_f.map { $0.c }
        XCTAssertEqual(chars.count, Set(chars).count, "code_f should have no duplicate c values")
    }

    func testCodeANoDuplicateMatchChars() {
        let chars = TelexRules.code_a.map { $0.c }
        XCTAssertEqual(chars.count, Set(chars).count, "code_a should have no duplicate c values")
    }

    func testCodeWNoDuplicateMatchChars() {
        let chars = TelexRules.code_w.map { $0.c }
        XCTAssertEqual(chars.count, Set(chars).count, "code_w should have no duplicate c values")
    }

    func testCodeDNoDuplicateMatchChars() {
        let chars = TelexRules.code_d.map { $0.c }
        XCTAssertEqual(chars.count, Set(chars).count, "code_d should have no duplicate c values")
    }

    // MARK: - 37. Full word integration tests

    func testFullWord_vieejt() {
        // "vieetj" -> v-i-ê-t with dot below on ê = việt
        // v, i, e, e->ê, t, j->dot below on ê = ệ => but tone goes on the vowel
        // Actually the engine places tone on the correct vowel in the buffer.
        // Let's just verify the engine processes without crashing and returns modifications.
        engine.clearBuffer()
        engine.inputMethod = .telex
        var modified = false
        for ch in "vieetj".unicodeScalars {
            let result = engine.addKey(UniChar(ch.value))
            if result >= 0 { modified = true }
        }
        XCTAssertTrue(modified, "vieetj should produce at least one modification")
    }

    func testFullWord_nguowif() {
        // nguowif -> ngươi + grave = người
        engine.clearBuffer()
        engine.inputMethod = .telex
        var modified = false
        for ch in "nguowif".unicodeScalars {
            let result = engine.addKey(UniChar(ch.value))
            if result >= 0 { modified = true }
        }
        XCTAssertTrue(modified, "nguowif should produce modifications for Vietnamese word")
    }

    func testFullWord_truowngf() {
        // truowngf -> trương + grave = trường
        engine.clearBuffer()
        engine.inputMethod = .telex
        var modified = false
        for ch in "truowngf".unicodeScalars {
            let result = engine.addKey(UniChar(ch.value))
            if result >= 0 { modified = true }
        }
        XCTAssertTrue(modified, "truowngf should produce modifications")
    }

    func testFullWord_ddaay() {
        // ddaay -> đây
        engine.clearBuffer()
        engine.inputMethod = .telex
        var ddModified = false
        var aaModified = false
        // d
        _ = engine.addKey(UniChar(0x64))
        // d -> đ
        let r1 = engine.addKey(UniChar(0x64))
        if r1 >= 0 { ddModified = true }
        // a
        _ = engine.addKey(UniChar(0x61))
        // a -> â
        let r2 = engine.addKey(UniChar(0x61))
        if r2 >= 0 { aaModified = true }
        // y
        _ = engine.addKey(UniChar(0x79))
        XCTAssertTrue(ddModified, "dd should modify to d-stroke")
        XCTAssertTrue(aaModified, "aa should modify to a-circumflex")
    }

    func testFullWord_laf() {
        // laf -> là
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x6C)) // l
        _ = engine.addKey(UniChar(0x61)) // a
        let result = engine.addKey(UniChar(0x66)) // f -> grave
        XCTAssertGreaterThanOrEqual(result, 0, "laf: 'f' should apply grave to 'a'")
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength))
            .filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.a2), "laf should produce a-grave")
    }

    func testFullWord_hoocj() {
        // hoocj -> hộc (o-circumflex-dot)
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x68)) // h
        _ = engine.addKey(UniChar(0x6F)) // o
        _ = engine.addKey(UniChar(0x6F)) // o -> circumflex
        _ = engine.addKey(UniChar(0x63)) // c
        let result = engine.addKey(UniChar(0x6A)) // j -> dot below on o-circumflex
        // The engine should place the tone on the vowel
        XCTAssertGreaterThanOrEqual(result, 0, "hoocj: 'j' should apply dot-below")
    }

    func testFullWord_thaats() {
        // thaats -> thất (a-circumflex-acute + t)
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x74)) // t
        _ = engine.addKey(UniChar(0x68)) // h
        _ = engine.addKey(UniChar(0x61)) // a
        _ = engine.addKey(UniChar(0x61)) // a -> circumflex
        _ = engine.addKey(UniChar(0x74)) // t
        let result = engine.addKey(UniChar(0x73)) // s -> acute
        XCTAssertGreaterThanOrEqual(result, 0, "thaats: 's' should apply acute to circumflex-a")
    }

    // MARK: - 38. Mixed case inputs

    func testMixedCase_As_producesUppercaseResult() {
        assertOutputContains("As", expected: Viet.A1, "As -> uppercase A-acute")
    }

    func testMixedCase_Es_producesUppercaseResult() {
        assertOutputContains("Es", expected: Viet.E1, "Es -> uppercase E-acute")
    }

    func testMixedCase_Os_producesUppercaseResult() {
        assertOutputContains("Os", expected: Viet.O1, "Os -> uppercase O-acute")
    }

    func testMixedCase_Us_producesUppercaseResult() {
        assertOutputContains("Us", expected: Viet.U1, "Us -> uppercase U-acute")
    }

    func testMixedCase_Is_producesUppercaseResult() {
        assertOutputContains("Is", expected: Viet.I1, "Is -> uppercase I-acute")
    }

    func testMixedCase_Ys_producesUppercaseResult() {
        assertOutputContains("Ys", expected: Viet.Y1, "Ys -> uppercase Y-acute")
    }

    // MARK: - 39. getOutputSlice correctness

    func testGetOutputSliceEmptyInitially() {
        engine.clearBuffer()
        let output = engine.getOutputSlice()
        XCTAssertEqual(output.outputLength, 0)
        XCTAssertEqual(output.backspaceCount, 0)
    }

    func testGetOutputSliceHasBackspacesAfterModification() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // a
        _ = engine.addKey(UniChar(0x73)) // s
        let output = engine.getOutputSlice()
        XCTAssertGreaterThan(output.backspaceCount, 0, "Should have backspaces to replace char")
        XCTAssertGreaterThan(output.outputLength, 0, "Should have output chars")
    }

    // MARK: - 40. Circumflex arrays map toned variants correctly

    func testCodeAMapsTonedA1ToCircumflexToned() {
        let entry = TelexRules.code_a.first(where: { $0.c == Viet.a1 })
        XCTAssertNotNil(entry)
        XCTAssertEqual(entry?.r1, Viet.a61, "a1 (acute) + a should produce a61 (circumflex-acute)")
    }

    func testCodeAMapsTonedA2ToCircumflexToned() {
        let entry = TelexRules.code_a.first(where: { $0.c == Viet.a2 })
        XCTAssertNotNil(entry)
        XCTAssertEqual(entry?.r1, Viet.a62, "a2 (grave) + a should produce a62 (circumflex-grave)")
    }

    func testCodeEMapsTonedE1ToCircumflexToned() {
        let entry = TelexRules.code_e.first(where: { $0.c == Viet.e1 })
        XCTAssertNotNil(entry)
        XCTAssertEqual(entry?.r1, Viet.e61, "e1 (acute) + e should produce e61 (circumflex-acute)")
    }

    func testCodeOMapsTonedO1ToCircumflexToned() {
        let entry = TelexRules.code_o.first(where: { $0.c == Viet.o1 })
        XCTAssertNotNil(entry)
        XCTAssertEqual(entry?.r1, Viet.o61, "o1 (acute) + o should produce o61 (circumflex-acute)")
    }

    // MARK: - 41. W arrays map toned variants correctly

    func testCodeWMapsTonedA1ToBreveAcute() {
        let entry = TelexRules.code_w.first(where: { $0.c == Viet.a1 })
        XCTAssertNotNil(entry)
        XCTAssertEqual(entry?.r1, Viet.a81, "a1 + w should produce a81 (breve-acute)")
    }

    func testCodeWMapsTonedO1ToHornAcute() {
        let entry = TelexRules.code_w.first(where: { $0.c == Viet.o1 })
        XCTAssertNotNil(entry)
        XCTAssertEqual(entry?.r1, Viet.o71, "o1 + w should produce o71 (horn-acute)")
    }

    func testCodeWMapsTonedU1ToHornAcute() {
        let entry = TelexRules.code_w.first(where: { $0.c == Viet.u1 })
        XCTAssertNotNil(entry)
        XCTAssertEqual(entry?.r1, Viet.u71, "u1 + w should produce u71 (horn-acute)")
    }

    // MARK: - 42. D arrays structure

    func testCodeDMapsPlainDToDStroke() {
        let entry = TelexRules.code_d.first(where: { $0.c == Viet.d })
        XCTAssertNotNil(entry)
        XCTAssertEqual(entry?.r1, Viet.d9)
    }

    func testCodeDMapsPlainUpperDToDStroke() {
        let entry = TelexRules.code_d.first(where: { $0.c == Viet.D })
        XCTAssertNotNil(entry)
        XCTAssertEqual(entry?.r1, Viet.D9)
    }

    func testCodeDMapsDStrokeBackToD() {
        let entry = TelexRules.code_d.first(where: { $0.c == Viet.d9 })
        XCTAssertNotNil(entry)
        XCTAssertEqual(entry?.r1, Viet.d, "d9 + d should revert to plain d")
        XCTAssertEqual(entry?.r2, Viet.d, "revert char should be 'd'")
    }

    // MARK: - 43. Thread-safe wrappers

    func testAddKeyThreadSafe() {
        engine.clearBuffer()
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

    // MARK: - 44. Uppercase tone arrays use uppercase modifier in revert

    func testCodeSUppercaseRevertUsesUppercaseModifier() {
        let revertEntries = TelexRules.code_S.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.S,
                           "code_S revert should use uppercase S (0x\(String(Viet.S, radix: 16)))")
        }
    }

    func testCodeFUppercaseRevertUsesUppercaseModifier() {
        let revertEntries = TelexRules.code_F.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.F)
        }
    }

    func testCodeRUppercaseRevertUsesUppercaseModifier() {
        let revertEntries = TelexRules.code_R.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.R)
        }
    }

    func testCodeXUppercaseRevertUsesUppercaseModifier() {
        let revertEntries = TelexRules.code_X.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.X)
        }
    }

    func testCodeJUppercaseRevertUsesUppercaseModifier() {
        let revertEntries = TelexRules.code_J.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.J)
        }
    }

    func testCodeWUppercaseRevertUsesUppercaseModifier() {
        let revertEntries = TelexRules.code_W.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.W)
        }
    }

    func testCodeDUppercaseRevertUsesUppercaseModifier() {
        let revertEntries = TelexRules.code_D.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.D)
        }
    }

    // MARK: - 45. Circumflex uppercase array revert chars

    func testCodeAUppercaseRevertChar() {
        let revertEntries = TelexRules.code_A.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.A,
                           "code_A revert should use uppercase A")
        }
    }

    func testCodeEUppercaseRevertChar() {
        let revertEntries = TelexRules.code_E.filter { $0.r2 != 0 }
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.E)
        }
    }

    func testCodeOUppercaseRevertChar() {
        let revertEntries = TelexRules.code_O.filter { $0.r2 != 0 }
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.O)
        }
    }

    // MARK: - 46. Circumflex lowercase array revert chars

    func testCodeALowercaseRevertChar() {
        let revertEntries = TelexRules.code_a.filter { $0.r2 != 0 }
        XCTAssertFalse(revertEntries.isEmpty)
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.a,
                           "code_a revert should use lowercase a")
        }
    }

    func testCodeELowercaseRevertChar() {
        let revertEntries = TelexRules.code_e.filter { $0.r2 != 0 }
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.e)
        }
    }

    func testCodeOLowercaseRevertChar() {
        let revertEntries = TelexRules.code_o.filter { $0.r2 != 0 }
        for entry in revertEntries {
            XCTAssertEqual(entry.r2, Viet.o)
        }
    }

    // MARK: - 47. Comprehensive tone on E vowel variants

    func testTelexEGrave_ef() {
        assertOutputContains("ef", expected: Viet.e2, "ef -> e-grave")
    }

    func testTelexEHook_er() {
        assertOutputContains("er", expected: Viet.e3, "er -> e-hook")
    }

    func testTelexETilde_ex() {
        assertOutputContains("ex", expected: Viet.e4, "ex -> e-tilde")
    }

    func testTelexEDot_ej() {
        assertOutputContains("ej", expected: Viet.e5, "ej -> e-dot")
    }

    // MARK: - 48. Comprehensive tone on O vowel variants

    func testTelexOGrave_of() {
        assertOutputContains("of", expected: Viet.o2, "of -> o-grave")
    }

    func testTelexOHook_or() {
        assertOutputContains("or", expected: Viet.o3, "or -> o-hook")
    }

    func testTelexOTilde_ox() {
        assertOutputContains("ox", expected: Viet.o4, "ox -> o-tilde")
    }

    func testTelexODot_oj() {
        assertOutputContains("oj", expected: Viet.o5, "oj -> o-dot")
    }

    // MARK: - 49. Space bar resets buffer for next word

    func testSpaceBarClearsBuffer() {
        engine.clearBuffer()
        engine.inputMethod = .telex
        _ = engine.addKey(UniChar(0x61)) // a
        _ = engine.addKey(KeyCode.spaceBar)
        _ = engine.addKey(UniChar(0x65)) // e
        let result = engine.addKey(UniChar(0x73)) // s -> acute on e
        XCTAssertGreaterThanOrEqual(result, 0, "After space, new word should accept modifiers")
        let output = engine.getOutputSlice()
        let nonBackspace = Array(output.pointer.prefix(output.backspaceCount + output.outputLength))
            .filter { $0 != 0x08 && $0 != 0 }
        XCTAssertTrue(nonBackspace.contains(Viet.e1), "After space + es should produce e-acute")
    }

    // MARK: - 50. Off mode does nothing

    func testOffModeIgnoresModifiers() {
        engine.clearBuffer()
        engine.inputMethod = .off
        _ = engine.addKey(UniChar(0x61)) // a
        let result = engine.addKey(UniChar(0x73)) // s
        XCTAssertEqual(result, -1, "Off mode should return -1 for all keys")
    }
}
