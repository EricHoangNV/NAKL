import XCTest
@testable import NAKL

final class CharacterTablesTests: XCTestCase {

    // MARK: - A group

    func testBaseACharacters() {
        XCTAssertEqual(Viet.A, 0x0041)
        XCTAssertEqual(Viet.a, 0x0061)
    }

    func testATonedCharacters() {
        // acute
        XCTAssertEqual(Viet.A1, 0x00C1)
        XCTAssertEqual(Viet.a1, 0x00E1)
        // grave
        XCTAssertEqual(Viet.A2, 0x00C0)
        XCTAssertEqual(Viet.a2, 0x00E0)
        // hook above
        XCTAssertEqual(Viet.A3, 0x1EA2)
        XCTAssertEqual(Viet.a3, 0x1EA3)
        // tilde
        XCTAssertEqual(Viet.A4, 0x00C3)
        XCTAssertEqual(Viet.a4, 0x00E3)
        // dot below
        XCTAssertEqual(Viet.A5, 0x1EA0)
        XCTAssertEqual(Viet.a5, 0x1EA1)
    }

    func testACircumflexCharacters() {
        XCTAssertEqual(Viet.A6, 0x00C2)
        XCTAssertEqual(Viet.a6, 0x00E2)
        XCTAssertEqual(Viet.A61, 0x1EA4)
        XCTAssertEqual(Viet.a61, 0x1EA5)
        XCTAssertEqual(Viet.A62, 0x1EA6)
        XCTAssertEqual(Viet.a62, 0x1EA7)
        XCTAssertEqual(Viet.A63, 0x1EA8)
        XCTAssertEqual(Viet.a63, 0x1EA9)
        XCTAssertEqual(Viet.A64, 0x1EAA)
        XCTAssertEqual(Viet.a64, 0x1EAB)
        XCTAssertEqual(Viet.A65, 0x1EAC)
        XCTAssertEqual(Viet.a65, 0x1EAD)
    }

    func testABreveCharacters() {
        XCTAssertEqual(Viet.A8, 0x0102)
        XCTAssertEqual(Viet.a8, 0x0103)
        XCTAssertEqual(Viet.A81, 0x1EAE)
        XCTAssertEqual(Viet.a81, 0x1EAF)
        XCTAssertEqual(Viet.A82, 0x1EB0)
        XCTAssertEqual(Viet.a82, 0x1EB1)
        XCTAssertEqual(Viet.A83, 0x1EB2)
        XCTAssertEqual(Viet.a83, 0x1EB3)
        XCTAssertEqual(Viet.A84, 0x1EB4)
        XCTAssertEqual(Viet.a84, 0x1EB5)
        XCTAssertEqual(Viet.A85, 0x1EB6)
        XCTAssertEqual(Viet.a85, 0x1EB7)
    }

    // MARK: - E group

    func testBaseECharacters() {
        XCTAssertEqual(Viet.E, 0x0045)
        XCTAssertEqual(Viet.e, 0x0065)
    }

    func testETonedCharacters() {
        XCTAssertEqual(Viet.E1, 0x00C9)
        XCTAssertEqual(Viet.e1, 0x00E9)
        XCTAssertEqual(Viet.E2, 0x00C8)
        XCTAssertEqual(Viet.e2, 0x00E8)
        XCTAssertEqual(Viet.E3, 0x1EBA)
        XCTAssertEqual(Viet.e3, 0x1EBB)
        XCTAssertEqual(Viet.E4, 0x1EBC)
        XCTAssertEqual(Viet.e4, 0x1EBD)
        XCTAssertEqual(Viet.E5, 0x1EB8)
        XCTAssertEqual(Viet.e5, 0x1EB9)
    }

    func testECircumflexCharacters() {
        XCTAssertEqual(Viet.E6, 0x00CA)
        XCTAssertEqual(Viet.e6, 0x00EA)
        XCTAssertEqual(Viet.E61, 0x1EBE)
        XCTAssertEqual(Viet.e61, 0x1EBF)
        XCTAssertEqual(Viet.E62, 0x1EC0)
        XCTAssertEqual(Viet.e62, 0x1EC1)
        XCTAssertEqual(Viet.E63, 0x1EC2)
        XCTAssertEqual(Viet.e63, 0x1EC3)
        XCTAssertEqual(Viet.E64, 0x1EC4)
        XCTAssertEqual(Viet.e64, 0x1EC5)
        XCTAssertEqual(Viet.E65, 0x1EC6)
        XCTAssertEqual(Viet.e65, 0x1EC7)
    }

    // MARK: - O group

    func testBaseOCharacters() {
        XCTAssertEqual(Viet.O, 0x004F)
        XCTAssertEqual(Viet.o, 0x006F)
    }

    func testOTonedCharacters() {
        XCTAssertEqual(Viet.O1, 0x00D3)
        XCTAssertEqual(Viet.o1, 0x00F3)
        XCTAssertEqual(Viet.O2, 0x00D2)
        XCTAssertEqual(Viet.o2, 0x00F2)
        XCTAssertEqual(Viet.O3, 0x1ECE)
        XCTAssertEqual(Viet.o3, 0x1ECF)
        XCTAssertEqual(Viet.O4, 0x00D5)
        XCTAssertEqual(Viet.o4, 0x00F5)
        XCTAssertEqual(Viet.O5, 0x1ECC)
        XCTAssertEqual(Viet.o5, 0x1ECD)
    }

    func testOCircumflexCharacters() {
        XCTAssertEqual(Viet.O6, 0x00D4)
        XCTAssertEqual(Viet.o6, 0x00F4)
        XCTAssertEqual(Viet.O61, 0x1ED0)
        XCTAssertEqual(Viet.o61, 0x1ED1)
        XCTAssertEqual(Viet.O62, 0x1ED2)
        XCTAssertEqual(Viet.o62, 0x1ED3)
        XCTAssertEqual(Viet.O63, 0x1ED4)
        XCTAssertEqual(Viet.o63, 0x1ED5)
        XCTAssertEqual(Viet.O64, 0x1ED6)
        XCTAssertEqual(Viet.o64, 0x1ED7)
        XCTAssertEqual(Viet.O65, 0x1ED8)
        XCTAssertEqual(Viet.o65, 0x1ED9)
    }

    func testOHornCharacters() {
        XCTAssertEqual(Viet.O7, 0x01A0)
        XCTAssertEqual(Viet.o7, 0x01A1)
        XCTAssertEqual(Viet.O71, 0x1EDA)
        XCTAssertEqual(Viet.o71, 0x1EDB)
        XCTAssertEqual(Viet.O72, 0x1EDC)
        XCTAssertEqual(Viet.o72, 0x1EDD)
        XCTAssertEqual(Viet.O73, 0x1EDE)
        XCTAssertEqual(Viet.o73, 0x1EDF)
        XCTAssertEqual(Viet.O74, 0x1EE0)
        XCTAssertEqual(Viet.o74, 0x1EE1)
        XCTAssertEqual(Viet.O75, 0x1EE2)
        XCTAssertEqual(Viet.o75, 0x1EE3)
    }

    // MARK: - U group

    func testBaseUCharacters() {
        XCTAssertEqual(Viet.U, 0x0055)
        XCTAssertEqual(Viet.u, 0x0075)
    }

    func testUTonedCharacters() {
        XCTAssertEqual(Viet.U1, 0x00DA)
        XCTAssertEqual(Viet.u1, 0x00FA)
        XCTAssertEqual(Viet.U2, 0x00D9)
        XCTAssertEqual(Viet.u2, 0x00F9)
        XCTAssertEqual(Viet.U3, 0x1EE6)
        XCTAssertEqual(Viet.u3, 0x1EE7)
        XCTAssertEqual(Viet.U4, 0x0168)
        XCTAssertEqual(Viet.u4, 0x0169)
        XCTAssertEqual(Viet.U5, 0x1EE4)
        XCTAssertEqual(Viet.u5, 0x1EE5)
    }

    func testUHornCharacters() {
        XCTAssertEqual(Viet.U7, 0x01AF)
        XCTAssertEqual(Viet.u7, 0x01B0)
        XCTAssertEqual(Viet.U71, 0x1EE8)
        XCTAssertEqual(Viet.u71, 0x1EE9)
        XCTAssertEqual(Viet.U72, 0x1EEA)
        XCTAssertEqual(Viet.u72, 0x1EEB)
        XCTAssertEqual(Viet.U73, 0x1EEC)
        XCTAssertEqual(Viet.u73, 0x1EED)
        XCTAssertEqual(Viet.U74, 0x1EEE)
        XCTAssertEqual(Viet.u74, 0x1EEF)
        XCTAssertEqual(Viet.U75, 0x1EF0)
        XCTAssertEqual(Viet.u75, 0x1EF1)
    }

    // MARK: - Y group

    func testBaseYCharacters() {
        XCTAssertEqual(Viet.Y, 0x0059)
        XCTAssertEqual(Viet.y, 0x0079)
    }

    func testYTonedCharacters() {
        XCTAssertEqual(Viet.Y1, 0x00DD)
        XCTAssertEqual(Viet.y1, 0x00FD)
        XCTAssertEqual(Viet.Y2, 0x1EF2)
        XCTAssertEqual(Viet.y2, 0x1EF3)
        XCTAssertEqual(Viet.Y3, 0x1EF6)
        XCTAssertEqual(Viet.y3, 0x1EF7)
        XCTAssertEqual(Viet.Y4, 0x1EF8)
        XCTAssertEqual(Viet.y4, 0x1EF9)
        XCTAssertEqual(Viet.Y5, 0x1EF4)
        XCTAssertEqual(Viet.y5, 0x1EF5)
    }

    // MARK: - I group

    func testBaseICharacters() {
        XCTAssertEqual(Viet.I, 0x0049)
        XCTAssertEqual(Viet.i, 0x0069)
    }

    func testITonedCharacters() {
        XCTAssertEqual(Viet.I1, 0x00CD)
        XCTAssertEqual(Viet.i1, 0x00ED)
        XCTAssertEqual(Viet.I2, 0x00CC)
        XCTAssertEqual(Viet.i2, 0x00EC)
        XCTAssertEqual(Viet.I3, 0x1EC8)
        XCTAssertEqual(Viet.i3, 0x1EC9)
        XCTAssertEqual(Viet.I4, 0x0128)
        XCTAssertEqual(Viet.i4, 0x0129)
        XCTAssertEqual(Viet.I5, 0x1ECA)
        XCTAssertEqual(Viet.i5, 0x1ECB)
    }

    // MARK: - D group

    func testDCharacters() {
        XCTAssertEqual(Viet.D, 0x0044)
        XCTAssertEqual(Viet.d, 0x0064)
        XCTAssertEqual(Viet.D9, 0x0110)
        XCTAssertEqual(Viet.d9, 0x0111)
        XCTAssertEqual(Viet.vnd, 0x20AB)
    }

    // MARK: - Modifier key characters

    func testModifierKeyCharacters() {
        XCTAssertEqual(Viet.W, 0x0057)
        XCTAssertEqual(Viet.w, 0x0077)
        XCTAssertEqual(Viet.S, 0x0053)
        XCTAssertEqual(Viet.s, 0x0073)
        XCTAssertEqual(Viet.F, 0x0046)
        XCTAssertEqual(Viet.f, 0x0066)
        XCTAssertEqual(Viet.R, 0x0052)
        XCTAssertEqual(Viet.r, 0x0072)
        XCTAssertEqual(Viet.X, 0x0058)
        XCTAssertEqual(Viet.x, 0x0078)
        XCTAssertEqual(Viet.J, 0x004A)
        XCTAssertEqual(Viet.j, 0x006A)
    }

    // MARK: - Case consistency

    func testUppercaseLowercasePairsHaveCorrectOffset() {
        // Base vowels: uppercase + 0x20 == lowercase (ASCII rule)
        XCTAssertEqual(Viet.a, Viet.A + 0x20)
        XCTAssertEqual(Viet.e, Viet.E + 0x20)
        XCTAssertEqual(Viet.o, Viet.O + 0x20)
        XCTAssertEqual(Viet.u, Viet.U + 0x20)
        XCTAssertEqual(Viet.y, Viet.Y + 0x20)
        XCTAssertEqual(Viet.i, Viet.I + 0x20)
        XCTAssertEqual(Viet.d, Viet.D + 0x20)
    }

    func testAccentedPairsAreDistinct() {
        // Toned versions differ from base
        XCTAssertNotEqual(Viet.a1, Viet.a)
        XCTAssertNotEqual(Viet.a2, Viet.a)
        XCTAssertNotEqual(Viet.a3, Viet.a)
        XCTAssertNotEqual(Viet.a4, Viet.a)
        XCTAssertNotEqual(Viet.a5, Viet.a)

        // Each tone mark produces a different codepoint
        let tones: [UInt16] = [Viet.a1, Viet.a2, Viet.a3, Viet.a4, Viet.a5]
        XCTAssertEqual(Set(tones).count, tones.count, "All toned 'a' chars should be unique")
    }

    func testNoDuplicatesInAGroup() {
        let aGroup: [UInt16] = [
            Viet.A, Viet.A1, Viet.A2, Viet.A3, Viet.A4, Viet.A5,
            Viet.A6, Viet.A61, Viet.A62, Viet.A63, Viet.A64, Viet.A65,
            Viet.A8, Viet.A81, Viet.A82, Viet.A83, Viet.A84, Viet.A85,
            Viet.a, Viet.a1, Viet.a2, Viet.a3, Viet.a4, Viet.a5,
            Viet.a6, Viet.a61, Viet.a62, Viet.a63, Viet.a64, Viet.a65,
            Viet.a8, Viet.a81, Viet.a82, Viet.a83, Viet.a84, Viet.a85,
        ]
        XCTAssertEqual(Set(aGroup).count, aGroup.count, "No duplicates in A group")
    }

    func testNoDuplicatesInEGroup() {
        let eGroup: [UInt16] = [
            Viet.E, Viet.E1, Viet.E2, Viet.E3, Viet.E4, Viet.E5,
            Viet.E6, Viet.E61, Viet.E62, Viet.E63, Viet.E64, Viet.E65,
            Viet.e, Viet.e1, Viet.e2, Viet.e3, Viet.e4, Viet.e5,
            Viet.e6, Viet.e61, Viet.e62, Viet.e63, Viet.e64, Viet.e65,
        ]
        XCTAssertEqual(Set(eGroup).count, eGroup.count, "No duplicates in E group")
    }

    func testNoDuplicatesInOGroup() {
        let oGroup: [UInt16] = [
            Viet.O, Viet.O1, Viet.O2, Viet.O3, Viet.O4, Viet.O5,
            Viet.O6, Viet.O61, Viet.O62, Viet.O63, Viet.O64, Viet.O65,
            Viet.O7, Viet.O71, Viet.O72, Viet.O73, Viet.O74, Viet.O75,
            Viet.o, Viet.o1, Viet.o2, Viet.o3, Viet.o4, Viet.o5,
            Viet.o6, Viet.o61, Viet.o62, Viet.o63, Viet.o64, Viet.o65,
            Viet.o7, Viet.o71, Viet.o72, Viet.o73, Viet.o74, Viet.o75,
        ]
        XCTAssertEqual(Set(oGroup).count, oGroup.count, "No duplicates in O group")
    }

    func testNoDuplicatesInUGroup() {
        let uGroup: [UInt16] = [
            Viet.U, Viet.U1, Viet.U2, Viet.U3, Viet.U4, Viet.U5,
            Viet.U7, Viet.U71, Viet.U72, Viet.U73, Viet.U74, Viet.U75,
            Viet.u, Viet.u1, Viet.u2, Viet.u3, Viet.u4, Viet.u5,
            Viet.u7, Viet.u71, Viet.u72, Viet.u73, Viet.u74, Viet.u75,
        ]
        XCTAssertEqual(Set(uGroup).count, uGroup.count, "No duplicates in U group")
    }

    func testNoDuplicatesInDGroup() {
        let dGroup: [UInt16] = [
            Viet.D, Viet.D9, Viet.d, Viet.d9, Viet.vnd,
        ]
        XCTAssertEqual(Set(dGroup).count, dGroup.count, "No duplicates in D group")
    }

    // MARK: - Unicode scalar validation

    func testCharactersAreValidUnicodeScalars() {
        let allChars: [UInt16] = [
            Viet.a, Viet.a1, Viet.a2, Viet.a3, Viet.a4, Viet.a5,
            Viet.a6, Viet.a61, Viet.a62, Viet.a63, Viet.a64, Viet.a65,
            Viet.a8, Viet.a81, Viet.a82, Viet.a83, Viet.a84, Viet.a85,
            Viet.e, Viet.e1, Viet.e2, Viet.e3, Viet.e4, Viet.e5,
            Viet.e6, Viet.e61, Viet.e62, Viet.e63, Viet.e64, Viet.e65,
            Viet.o, Viet.o1, Viet.o2, Viet.o3, Viet.o4, Viet.o5,
            Viet.o6, Viet.o61, Viet.o62, Viet.o63, Viet.o64, Viet.o65,
            Viet.o7, Viet.o71, Viet.o72, Viet.o73, Viet.o74, Viet.o75,
            Viet.u, Viet.u1, Viet.u2, Viet.u3, Viet.u4, Viet.u5,
            Viet.u7, Viet.u71, Viet.u72, Viet.u73, Viet.u74, Viet.u75,
            Viet.y, Viet.y1, Viet.y2, Viet.y3, Viet.y4, Viet.y5,
            Viet.i, Viet.i1, Viet.i2, Viet.i3, Viet.i4, Viet.i5,
            Viet.d, Viet.d9, Viet.vnd,
        ]
        for code in allChars {
            XCTAssertNotNil(
                UnicodeScalar(UInt32(code)),
                "Codepoint 0x\(String(code, radix: 16)) should be a valid Unicode scalar"
            )
        }
    }

    func testSpotCheckUnicodeCharacters() {
        // Verify that codepoints match expected Unicode characters
        XCTAssertEqual(String(UnicodeScalar(UInt32(Viet.a1))!), "\u{00E1}") // a with acute
        XCTAssertEqual(String(UnicodeScalar(UInt32(Viet.a2))!), "\u{00E0}") // a with grave
        XCTAssertEqual(String(UnicodeScalar(UInt32(Viet.d9))!), "\u{0111}") // d with stroke
        XCTAssertEqual(String(UnicodeScalar(UInt32(Viet.D9))!), "\u{0110}") // D with stroke
        XCTAssertEqual(String(UnicodeScalar(UInt32(Viet.vnd))!), "\u{20AB}") // dong sign
    }
}
