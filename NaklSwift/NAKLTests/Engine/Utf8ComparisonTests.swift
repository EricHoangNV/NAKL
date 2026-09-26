import XCTest
@testable import NAKL

final class Utf8ComparisonTests: XCTestCase {

    private var engine: VietnameseEngine!

    override func setUp() {
        super.setUp()
        engine = VietnameseEngine()
    }

    override func tearDown() {
        engine = nil
        super.tearDown()
    }

    // MARK: - Identity comparison

    func testSameCharacterReturnsZero() {
        XCTAssertEqual(engine.utfVnCmp(Viet.a, Viet.a), 0)
        XCTAssertEqual(engine.utfVnCmp(Viet.A, Viet.A), 0)
        XCTAssertEqual(engine.utfVnCmp(Viet.e, Viet.e), 0)
        XCTAssertEqual(engine.utfVnCmp(Viet.o6, Viet.o6), 0)
        XCTAssertEqual(engine.utfVnCmp(Viet.u7, Viet.u7), 0)
        XCTAssertEqual(engine.utfVnCmp(Viet.d9, Viet.d9), 0)
    }

    // MARK: - Ordering within same base vowel

    func testLowercaseBeforeUppercaseWithinPair() {
        // In the ordering array, lowercase 'a' comes before uppercase 'A'
        // Actually the array is: Viet.a, Viet.A, Viet.a1, Viet.A1, ...
        // So a is at index 0, A is at index 1 => a < A
        XCTAssertLessThan(engine.utfVnCmp(Viet.a, Viet.A), 0)
        XCTAssertGreaterThan(engine.utfVnCmp(Viet.A, Viet.a), 0)
    }

    func testTonedAfterBase() {
        // a (index 0) < a1 (index 2)
        XCTAssertLessThan(engine.utfVnCmp(Viet.a, Viet.a1), 0)
        XCTAssertLessThan(engine.utfVnCmp(Viet.a, Viet.a2), 0)
        XCTAssertLessThan(engine.utfVnCmp(Viet.a, Viet.a3), 0)
        XCTAssertLessThan(engine.utfVnCmp(Viet.a, Viet.a4), 0)
        XCTAssertLessThan(engine.utfVnCmp(Viet.a, Viet.a5), 0)
    }

    func testToneOrderAcuteBeforeGrave() {
        // a1 (acute, index 2) < a2 (grave, index 4)
        XCTAssertLessThan(engine.utfVnCmp(Viet.a1, Viet.a2), 0)
        XCTAssertGreaterThan(engine.utfVnCmp(Viet.a2, Viet.a1), 0)
    }

    func testCircumflexAfterBase() {
        // a6 (circumflex base) comes after a5 (dot below)
        XCTAssertLessThan(engine.utfVnCmp(Viet.a5, Viet.a6), 0)
    }

    func testBreveAfterCircumflex() {
        // a8 (breve base) comes after a65 in the ordering
        XCTAssertLessThan(engine.utfVnCmp(Viet.a6, Viet.a8), 0)
    }

    // MARK: - Cross-group comparison

    func testABeforeE() {
        // A group is before E group in the array
        XCTAssertLessThan(engine.utfVnCmp(Viet.a, Viet.e), 0)
        XCTAssertGreaterThan(engine.utfVnCmp(Viet.e, Viet.a), 0)
    }

    func testEBeforeO() {
        XCTAssertLessThan(engine.utfVnCmp(Viet.e, Viet.o), 0)
        XCTAssertGreaterThan(engine.utfVnCmp(Viet.o, Viet.e), 0)
    }

    func testOBeforeY() {
        // In the ordering array, O group comes before Y group
        XCTAssertLessThan(engine.utfVnCmp(Viet.o, Viet.y), 0)
    }

    func testYBeforeU() {
        // In the ordering array, Y group comes before U group
        XCTAssertLessThan(engine.utfVnCmp(Viet.y, Viet.u), 0)
    }

    func testUBeforeI() {
        // In the ordering array, U group comes before I group
        XCTAssertLessThan(engine.utfVnCmp(Viet.u, Viet.i), 0)
    }

    func testDBarAtEnd() {
        // d9 and D9 are at the very end of the ordering array
        XCTAssertLessThan(engine.utfVnCmp(Viet.i, Viet.d9), 0)
        XCTAssertLessThan(engine.utfVnCmp(Viet.i5, Viet.d9), 0)
    }

    // MARK: - Symmetry (anti-symmetry)

    func testAntiSymmetry() {
        let pairs: [(UInt16, UInt16)] = [
            (Viet.a, Viet.e),
            (Viet.o, Viet.u),
            (Viet.a1, Viet.a2),
            (Viet.e6, Viet.o6),
        ]
        for (a, b) in pairs {
            let ab = engine.utfVnCmp(a, b)
            let ba = engine.utfVnCmp(b, a)
            XCTAssertEqual(ab, -ba, "utfVnCmp should be anti-symmetric for 0x\(String(a, radix: 16)) vs 0x\(String(b, radix: 16))")
        }
    }

    // MARK: - Characters not in the Vietnamese ordering

    func testNonVietnameseCharReturnsNegativeIndex() {
        // Characters not in the v array get index -1
        // Comparing two non-Vietnamese chars: both get -1 => difference is 0
        let result = engine.utfVnCmp(0x0062, 0x0063) // 'b' vs 'c'
        XCTAssertEqual(result, 0, "Two non-Vietnamese chars should compare as equal (both index -1)")
    }

    func testVietnameseVsNonVietnamese() {
        // Vietnamese char has index >= 0, non-Vietnamese gets -1
        // So Vietnamese char > non-Vietnamese
        let result = engine.utfVnCmp(Viet.a, 0x0062) // 'a' vs 'b'
        XCTAssertGreaterThan(result, 0, "Vietnamese 'a' should sort after non-Vietnamese 'b'")
    }

    func testNonVietnameseVsVietnamese() {
        let result = engine.utfVnCmp(0x0062, Viet.a) // 'b' vs 'a'
        XCTAssertLessThan(result, 0, "Non-Vietnamese should sort before Vietnamese")
    }

    // MARK: - Horn variants

    func testOHornAfterOCircumflex() {
        // o6 (circumflex) comes before o7 (horn) in ordering
        XCTAssertLessThan(engine.utfVnCmp(Viet.o6, Viet.o7), 0)
    }

    func testUHornAfterUBase() {
        // u (base) comes before u7 (horn) in ordering
        XCTAssertLessThan(engine.utfVnCmp(Viet.u, Viet.u7), 0)
    }
}
