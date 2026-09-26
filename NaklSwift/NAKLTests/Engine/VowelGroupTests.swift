import XCTest
@testable import NAKL

final class VowelGroupTests: XCTestCase {

    private var engine: VietnameseEngine!

    override func setUp() {
        super.setUp()
        engine = VietnameseEngine()
    }

    override func tearDown() {
        engine = nil
        super.tearDown()
    }

    // MARK: - U group (indices 1-24)

    func testUppercaseUBaseReturnsGroup() {
        // U, U1, U2, U3, U4, U5 => indices 1-6
        XCTAssertEqual(engine.uiGroup(Viet.U), 1)
        XCTAssertEqual(engine.uiGroup(Viet.U1), 2)
        XCTAssertEqual(engine.uiGroup(Viet.U2), 3)
        XCTAssertEqual(engine.uiGroup(Viet.U3), 4)
        XCTAssertEqual(engine.uiGroup(Viet.U4), 5)
        XCTAssertEqual(engine.uiGroup(Viet.U5), 6)
    }

    func testLowercaseUBaseReturnsGroup() {
        // u, u1, u2, u3, u4, u5 => indices 7-12
        XCTAssertEqual(engine.uiGroup(Viet.u), 7)
        XCTAssertEqual(engine.uiGroup(Viet.u1), 8)
        XCTAssertEqual(engine.uiGroup(Viet.u2), 9)
        XCTAssertEqual(engine.uiGroup(Viet.u3), 10)
        XCTAssertEqual(engine.uiGroup(Viet.u4), 11)
        XCTAssertEqual(engine.uiGroup(Viet.u5), 12)
    }

    func testUppercaseUHornReturnsGroup() {
        // U7, U71..U75 => indices 13-18
        XCTAssertEqual(engine.uiGroup(Viet.U7), 13)
        XCTAssertEqual(engine.uiGroup(Viet.U71), 14)
        XCTAssertEqual(engine.uiGroup(Viet.U72), 15)
        XCTAssertEqual(engine.uiGroup(Viet.U73), 16)
        XCTAssertEqual(engine.uiGroup(Viet.U74), 17)
        XCTAssertEqual(engine.uiGroup(Viet.U75), 18)
    }

    func testLowercaseUHornReturnsGroup() {
        // u7, u71..u75 => indices 19-24
        XCTAssertEqual(engine.uiGroup(Viet.u7), 19)
        XCTAssertEqual(engine.uiGroup(Viet.u71), 20)
        XCTAssertEqual(engine.uiGroup(Viet.u72), 21)
        XCTAssertEqual(engine.uiGroup(Viet.u73), 22)
        XCTAssertEqual(engine.uiGroup(Viet.u74), 23)
        XCTAssertEqual(engine.uiGroup(Viet.u75), 24)
    }

    // MARK: - I group (indices 25-36)

    func testUppercaseIReturnsGroup() {
        // I, I1..I5 => indices 25-30
        XCTAssertEqual(engine.uiGroup(Viet.I), 25)
        XCTAssertEqual(engine.uiGroup(Viet.I1), 26)
        XCTAssertEqual(engine.uiGroup(Viet.I2), 27)
        XCTAssertEqual(engine.uiGroup(Viet.I3), 28)
        XCTAssertEqual(engine.uiGroup(Viet.I4), 29)
        XCTAssertEqual(engine.uiGroup(Viet.I5), 30)
    }

    func testLowercaseIReturnsGroup() {
        // i, i1..i5 => indices 31-36
        XCTAssertEqual(engine.uiGroup(Viet.i), 31)
        XCTAssertEqual(engine.uiGroup(Viet.i1), 32)
        XCTAssertEqual(engine.uiGroup(Viet.i2), 33)
        XCTAssertEqual(engine.uiGroup(Viet.i3), 34)
        XCTAssertEqual(engine.uiGroup(Viet.i4), 35)
        XCTAssertEqual(engine.uiGroup(Viet.i5), 36)
    }

    // MARK: - Non-UI characters return 0

    func testNonVietnameseCharsReturnZero() {
        // Basic ASCII letters not in the UI group
        XCTAssertEqual(engine.uiGroup(Viet.a), 0)
        XCTAssertEqual(engine.uiGroup(Viet.A), 0)
        XCTAssertEqual(engine.uiGroup(Viet.e), 0)
        XCTAssertEqual(engine.uiGroup(Viet.E), 0)
        XCTAssertEqual(engine.uiGroup(Viet.o), 0)
        XCTAssertEqual(engine.uiGroup(Viet.O), 0)
        XCTAssertEqual(engine.uiGroup(Viet.y), 0)
        XCTAssertEqual(engine.uiGroup(Viet.Y), 0)
        XCTAssertEqual(engine.uiGroup(Viet.d), 0)
        XCTAssertEqual(engine.uiGroup(Viet.D), 0)
    }

    func testPlainASCIIReturnsZero() {
        // Random ASCII characters
        XCTAssertEqual(engine.uiGroup(0x0062), 0) // 'b'
        XCTAssertEqual(engine.uiGroup(0x007A), 0) // 'z'
        XCTAssertEqual(engine.uiGroup(0x0030), 0) // '0'
        XCTAssertEqual(engine.uiGroup(0x0020), 0) // space
    }

    func testAccentedACharsReturnZero() {
        // A-group toned chars are NOT in the UI group
        XCTAssertEqual(engine.uiGroup(Viet.a1), 0)
        XCTAssertEqual(engine.uiGroup(Viet.a6), 0)
        XCTAssertEqual(engine.uiGroup(Viet.a8), 0)
    }

    // MARK: - Boundary checks

    func testAllUGroupCharsAreInRange1To24() {
        let uChars: [UInt16] = [
            Viet.U, Viet.U1, Viet.U2, Viet.U3, Viet.U4, Viet.U5,
            Viet.u, Viet.u1, Viet.u2, Viet.u3, Viet.u4, Viet.u5,
            Viet.U7, Viet.U71, Viet.U72, Viet.U73, Viet.U74, Viet.U75,
            Viet.u7, Viet.u71, Viet.u72, Viet.u73, Viet.u74, Viet.u75,
        ]
        for ch in uChars {
            let group = engine.uiGroup(ch)
            XCTAssertTrue(
                group >= 1 && group <= 24,
                "U-group char 0x\(String(ch, radix: 16)) returned group \(group), expected 1-24"
            )
        }
    }

    func testAllIGroupCharsAreInRange25To36() {
        let iChars: [UInt16] = [
            Viet.I, Viet.I1, Viet.I2, Viet.I3, Viet.I4, Viet.I5,
            Viet.i, Viet.i1, Viet.i2, Viet.i3, Viet.i4, Viet.i5,
        ]
        for ch in iChars {
            let group = engine.uiGroup(ch)
            XCTAssertTrue(
                group >= 25 && group <= 36,
                "I-group char 0x\(String(ch, radix: 16)) returned group \(group), expected 25-36"
            )
        }
    }
}
