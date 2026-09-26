//
//  VNIRules.swift
//  NAKL
//
//  Ported from utf.h (VNI-specific rule arrays)
//  Original copyright (C) 2002 by Dao Hai Lam, VISC Software & Security Consultant Company
//  Licensed under the GNU General Public License v2 or later.
//

import Foundation

// VietCode struct is defined in TelexRules.swift -- reuse it here.

enum VNIRules {

    // MARK: - code_6: Circumflex (^) via key '6'

    static let code_6: [VietCode] = [
        // A uppercase
        VietCode(Viet.A,   Viet.A6),
        VietCode(Viet.A1,  Viet.A61),
        VietCode(Viet.A2,  Viet.A62),
        VietCode(Viet.A3,  Viet.A63),
        VietCode(Viet.A4,  Viet.A64),
        VietCode(Viet.A5,  Viet.A65),
        VietCode(Viet.A6,  Viet.A,  0x36),
        VietCode(Viet.A61, Viet.A1, 0x36),
        VietCode(Viet.A62, Viet.A2, 0x36),
        VietCode(Viet.A63, Viet.A3, 0x36),
        VietCode(Viet.A64, Viet.A4, 0x36),
        VietCode(Viet.A65, Viet.A5, 0x36),
        VietCode(Viet.A8,  Viet.A6),
        VietCode(Viet.A81, Viet.A61),
        VietCode(Viet.A82, Viet.A62),
        VietCode(Viet.A83, Viet.A63),
        VietCode(Viet.A84, Viet.A64),
        VietCode(Viet.A85, Viet.A65),

        // a lowercase
        VietCode(Viet.a,   Viet.a6),
        VietCode(Viet.a1,  Viet.a61),
        VietCode(Viet.a2,  Viet.a62),
        VietCode(Viet.a3,  Viet.a63),
        VietCode(Viet.a4,  Viet.a64),
        VietCode(Viet.a5,  Viet.a65),
        VietCode(Viet.a6,  Viet.a,  0x36),
        VietCode(Viet.a61, Viet.a1, 0x36),
        VietCode(Viet.a62, Viet.a2, 0x36),
        VietCode(Viet.a63, Viet.a3, 0x36),
        VietCode(Viet.a64, Viet.a4, 0x36),
        VietCode(Viet.a65, Viet.a5, 0x36),
        VietCode(Viet.a8,  Viet.a6),
        VietCode(Viet.a81, Viet.a61),
        VietCode(Viet.a82, Viet.a62),
        VietCode(Viet.a83, Viet.a63),
        VietCode(Viet.a84, Viet.a64),
        VietCode(Viet.a85, Viet.a65),

        // E uppercase
        VietCode(Viet.E,   Viet.E6),
        VietCode(Viet.E1,  Viet.E61),
        VietCode(Viet.E2,  Viet.E62),
        VietCode(Viet.E3,  Viet.E63),
        VietCode(Viet.E4,  Viet.E64),
        VietCode(Viet.E5,  Viet.E65),
        VietCode(Viet.E6,  Viet.E,  0x36),
        VietCode(Viet.E61, Viet.E1, 0x36),
        VietCode(Viet.E62, Viet.E2, 0x36),
        VietCode(Viet.E63, Viet.E3, 0x36),
        VietCode(Viet.E64, Viet.E4, 0x36),
        VietCode(Viet.E65, Viet.E5, 0x36),

        // e lowercase
        VietCode(Viet.e,   Viet.e6),
        VietCode(Viet.e1,  Viet.e61),
        VietCode(Viet.e2,  Viet.e62),
        VietCode(Viet.e3,  Viet.e63),
        VietCode(Viet.e4,  Viet.e64),
        VietCode(Viet.e5,  Viet.e65),
        VietCode(Viet.e6,  Viet.e,  0x36),
        VietCode(Viet.e61, Viet.e1, 0x36),
        VietCode(Viet.e62, Viet.e2, 0x36),
        VietCode(Viet.e63, Viet.e3, 0x36),
        VietCode(Viet.e64, Viet.e4, 0x36),
        VietCode(Viet.e65, Viet.e5, 0x36),

        // O uppercase
        VietCode(Viet.O,   Viet.O6),
        VietCode(Viet.O1,  Viet.O61),
        VietCode(Viet.O2,  Viet.O62),
        VietCode(Viet.O3,  Viet.O63),
        VietCode(Viet.O4,  Viet.O64),
        VietCode(Viet.O5,  Viet.O65),
        VietCode(Viet.O6,  Viet.O,  0x36),
        VietCode(Viet.O61, Viet.O1, 0x36),
        VietCode(Viet.O62, Viet.O2, 0x36),
        VietCode(Viet.O63, Viet.O3, 0x36),
        VietCode(Viet.O64, Viet.O4, 0x36),
        VietCode(Viet.O65, Viet.O5, 0x36),
        VietCode(Viet.O7,  Viet.O6),
        VietCode(Viet.O71, Viet.O61),
        VietCode(Viet.O72, Viet.O62),
        VietCode(Viet.O73, Viet.O63),
        VietCode(Viet.O74, Viet.O64),
        VietCode(Viet.O75, Viet.O65),

        // o lowercase
        VietCode(Viet.o,   Viet.o6),
        VietCode(Viet.o1,  Viet.o61),
        VietCode(Viet.o2,  Viet.o62),
        VietCode(Viet.o3,  Viet.o63),
        VietCode(Viet.o4,  Viet.o64),
        VietCode(Viet.o5,  Viet.o65),
        VietCode(Viet.o6,  Viet.o,  0x36),
        VietCode(Viet.o61, Viet.o1, 0x36),
        VietCode(Viet.o62, Viet.o2, 0x36),
        VietCode(Viet.o63, Viet.o3, 0x36),
        VietCode(Viet.o64, Viet.o4, 0x36),
        VietCode(Viet.o65, Viet.o5, 0x36),
        VietCode(Viet.o7,  Viet.o6),
        VietCode(Viet.o71, Viet.o61),
        VietCode(Viet.o72, Viet.o62),
        VietCode(Viet.o73, Viet.o63),
        VietCode(Viet.o74, Viet.o64),
        VietCode(Viet.o75, Viet.o65),
    ]

    // MARK: - code_7: Horn (o+/u+) via key '7'

    static let code_7: [VietCode] = [
        // O uppercase
        VietCode(Viet.O,   Viet.O7),
        VietCode(Viet.O1,  Viet.O71),
        VietCode(Viet.O2,  Viet.O72),
        VietCode(Viet.O3,  Viet.O73),
        VietCode(Viet.O4,  Viet.O74),
        VietCode(Viet.O5,  Viet.O75),
        VietCode(Viet.O6,  Viet.O7),
        VietCode(Viet.O61, Viet.O71),
        VietCode(Viet.O62, Viet.O72),
        VietCode(Viet.O63, Viet.O73),
        VietCode(Viet.O64, Viet.O74),
        VietCode(Viet.O65, Viet.O75),
        VietCode(Viet.O7,  Viet.O,  0x37),
        VietCode(Viet.O71, Viet.O1, 0x37),
        VietCode(Viet.O72, Viet.O2, 0x37),
        VietCode(Viet.O73, Viet.O3, 0x37),
        VietCode(Viet.O74, Viet.O4, 0x37),
        VietCode(Viet.O75, Viet.O5, 0x37),

        // o lowercase
        VietCode(Viet.o,   Viet.o7),
        VietCode(Viet.o1,  Viet.o71),
        VietCode(Viet.o2,  Viet.o72),
        VietCode(Viet.o3,  Viet.o73),
        VietCode(Viet.o4,  Viet.o74),
        VietCode(Viet.o5,  Viet.o75),
        VietCode(Viet.o6,  Viet.o7),
        VietCode(Viet.o61, Viet.o71),
        VietCode(Viet.o62, Viet.o72),
        VietCode(Viet.o63, Viet.o73),
        VietCode(Viet.o64, Viet.o74),
        VietCode(Viet.o65, Viet.o75),
        VietCode(Viet.o7,  Viet.o,  0x37),
        VietCode(Viet.o71, Viet.o1, 0x37),
        VietCode(Viet.o72, Viet.o2, 0x37),
        VietCode(Viet.o73, Viet.o3, 0x37),
        VietCode(Viet.o74, Viet.o4, 0x37),
        VietCode(Viet.o75, Viet.o5, 0x37),

        // U uppercase
        VietCode(Viet.U,   Viet.U7),
        VietCode(Viet.U1,  Viet.U71),
        VietCode(Viet.U2,  Viet.U72),
        VietCode(Viet.U3,  Viet.U73),
        VietCode(Viet.U4,  Viet.U74),
        VietCode(Viet.U5,  Viet.U75),
        VietCode(Viet.U7,  Viet.U,  0x37),
        VietCode(Viet.U71, Viet.U1, 0x37),
        VietCode(Viet.U72, Viet.U2, 0x37),
        VietCode(Viet.U73, Viet.U3, 0x37),
        VietCode(Viet.U74, Viet.U4, 0x37),
        VietCode(Viet.U75, Viet.U5, 0x37),

        // u lowercase
        VietCode(Viet.u,   Viet.u7),
        VietCode(Viet.u1,  Viet.u71),
        VietCode(Viet.u2,  Viet.u72),
        VietCode(Viet.u3,  Viet.u73),
        VietCode(Viet.u4,  Viet.u74),
        VietCode(Viet.u5,  Viet.u75),
        VietCode(Viet.u7,  Viet.u,  0x37),
        VietCode(Viet.u71, Viet.u1, 0x37),
        VietCode(Viet.u72, Viet.u2, 0x37),
        VietCode(Viet.u73, Viet.u3, 0x37),
        VietCode(Viet.u74, Viet.u4, 0x37),
        VietCode(Viet.u75, Viet.u5, 0x37),
    ]

    // MARK: - code_8: Breve (a() via key '8'

    static let code_8: [VietCode] = [
        // A uppercase
        VietCode(Viet.A,   Viet.A8),
        VietCode(Viet.A1,  Viet.A81),
        VietCode(Viet.A2,  Viet.A82),
        VietCode(Viet.A3,  Viet.A83),
        VietCode(Viet.A4,  Viet.A84),
        VietCode(Viet.A5,  Viet.A85),
        VietCode(Viet.A6,  Viet.A8),
        VietCode(Viet.A61, Viet.A81),
        VietCode(Viet.A62, Viet.A82),
        VietCode(Viet.A63, Viet.A83),
        VietCode(Viet.A64, Viet.A84),
        VietCode(Viet.A65, Viet.A85),
        VietCode(Viet.A8,  Viet.A,  0x38),
        VietCode(Viet.A81, Viet.A1, 0x38),
        VietCode(Viet.A82, Viet.A2, 0x38),
        VietCode(Viet.A83, Viet.A3, 0x38),
        VietCode(Viet.A84, Viet.A4, 0x38),
        VietCode(Viet.A85, Viet.A5, 0x38),

        // a lowercase
        VietCode(Viet.a,   Viet.a8),
        VietCode(Viet.a1,  Viet.a81),
        VietCode(Viet.a2,  Viet.a82),
        VietCode(Viet.a3,  Viet.a83),
        VietCode(Viet.a4,  Viet.a84),
        VietCode(Viet.a5,  Viet.a85),
        VietCode(Viet.a6,  Viet.a8),
        VietCode(Viet.a61, Viet.a81),
        VietCode(Viet.a62, Viet.a82),
        VietCode(Viet.a63, Viet.a83),
        VietCode(Viet.a64, Viet.a84),
        VietCode(Viet.a65, Viet.a85),
        VietCode(Viet.a8,  Viet.a,  0x38),
        VietCode(Viet.a81, Viet.a1, 0x38),
        VietCode(Viet.a82, Viet.a2, 0x38),
        VietCode(Viet.a83, Viet.a3, 0x38),
        VietCode(Viet.a84, Viet.a4, 0x38),
        VietCode(Viet.a85, Viet.a5, 0x38),
    ]

    // MARK: - code_9: D-bar via key '9'

    static let code_9: [VietCode] = [
        VietCode(Viet.D,  Viet.D9),
        VietCode(Viet.D9, Viet.D,  0x39),
        VietCode(Viet.d,  Viet.d9),
        VietCode(Viet.d9, Viet.d,  0x39),
    ]

    // MARK: - code_1: Acute (') via key '1'

    static let code_1: [VietCode] = [
        // A uppercase
        VietCode(Viet.A,   Viet.A1),
        VietCode(Viet.A1,  Viet.A,  0x31),
        VietCode(Viet.A2,  Viet.A1),
        VietCode(Viet.A3,  Viet.A1),
        VietCode(Viet.A4,  Viet.A1),
        VietCode(Viet.A5,  Viet.A1),

        VietCode(Viet.A6,  Viet.A61),
        VietCode(Viet.A61, Viet.A6, 0x31),
        VietCode(Viet.A62, Viet.A61),
        VietCode(Viet.A63, Viet.A61),
        VietCode(Viet.A64, Viet.A61),
        VietCode(Viet.A65, Viet.A61),

        VietCode(Viet.A8,  Viet.A81),
        VietCode(Viet.A81, Viet.A8, 0x31),
        VietCode(Viet.A82, Viet.A81),
        VietCode(Viet.A83, Viet.A81),
        VietCode(Viet.A84, Viet.A81),
        VietCode(Viet.A85, Viet.A81),

        // E uppercase
        VietCode(Viet.E,   Viet.E1),
        VietCode(Viet.E1,  Viet.E,  0x31),
        VietCode(Viet.E2,  Viet.E1),
        VietCode(Viet.E3,  Viet.E1),
        VietCode(Viet.E4,  Viet.E1),
        VietCode(Viet.E5,  Viet.E1),

        VietCode(Viet.E6,  Viet.E61),
        VietCode(Viet.E61, Viet.E6, 0x31),
        VietCode(Viet.E62, Viet.E61),
        VietCode(Viet.E63, Viet.E61),
        VietCode(Viet.E64, Viet.E61),
        VietCode(Viet.E65, Viet.E61),

        // O uppercase
        VietCode(Viet.O,   Viet.O1),
        VietCode(Viet.O1,  Viet.O,  0x31),
        VietCode(Viet.O2,  Viet.O1),
        VietCode(Viet.O3,  Viet.O1),
        VietCode(Viet.O4,  Viet.O1),
        VietCode(Viet.O5,  Viet.O1),

        VietCode(Viet.O6,  Viet.O61),
        VietCode(Viet.O61, Viet.O6, 0x31),
        VietCode(Viet.O62, Viet.O61),
        VietCode(Viet.O63, Viet.O61),
        VietCode(Viet.O64, Viet.O61),
        VietCode(Viet.O65, Viet.O61),

        VietCode(Viet.O7,  Viet.O71),
        VietCode(Viet.O71, Viet.O7, 0x31),
        VietCode(Viet.O72, Viet.O71),
        VietCode(Viet.O73, Viet.O71),
        VietCode(Viet.O74, Viet.O71),
        VietCode(Viet.O75, Viet.O71),

        // U uppercase
        VietCode(Viet.U,   Viet.U1),
        VietCode(Viet.U1,  Viet.U,  0x31),
        VietCode(Viet.U2,  Viet.U1),
        VietCode(Viet.U3,  Viet.U1),
        VietCode(Viet.U4,  Viet.U1),
        VietCode(Viet.U5,  Viet.U1),

        VietCode(Viet.U7,  Viet.U71),
        VietCode(Viet.U71, Viet.U7, 0x31),
        VietCode(Viet.U72, Viet.U71),
        VietCode(Viet.U73, Viet.U71),
        VietCode(Viet.U74, Viet.U71),
        VietCode(Viet.U75, Viet.U71),

        // I uppercase
        VietCode(Viet.I,   Viet.I1),
        VietCode(Viet.I1,  Viet.I,  0x31),
        VietCode(Viet.I2,  Viet.I1),
        VietCode(Viet.I3,  Viet.I1),
        VietCode(Viet.I4,  Viet.I1),
        VietCode(Viet.I5,  Viet.I1),

        // Y uppercase
        VietCode(Viet.Y,   Viet.Y1),
        VietCode(Viet.Y1,  Viet.Y,  0x31),
        VietCode(Viet.Y2,  Viet.Y1),
        VietCode(Viet.Y3,  Viet.Y1),
        VietCode(Viet.Y4,  Viet.Y1),
        VietCode(Viet.Y5,  Viet.Y1),

        // a lowercase
        VietCode(Viet.a,   Viet.a1),
        VietCode(Viet.a1,  Viet.a,  0x31),
        VietCode(Viet.a2,  Viet.a1),
        VietCode(Viet.a3,  Viet.a1),
        VietCode(Viet.a4,  Viet.a1),
        VietCode(Viet.a5,  Viet.a1),

        VietCode(Viet.a6,  Viet.a61),
        VietCode(Viet.a61, Viet.a6, 0x31),
        VietCode(Viet.a62, Viet.a61),
        VietCode(Viet.a63, Viet.a61),
        VietCode(Viet.a64, Viet.a61),
        VietCode(Viet.a65, Viet.a61),

        VietCode(Viet.a8,  Viet.a81),
        VietCode(Viet.a81, Viet.a8, 0x31),
        VietCode(Viet.a82, Viet.a81),
        VietCode(Viet.a83, Viet.a81),
        VietCode(Viet.a84, Viet.a81),
        VietCode(Viet.a85, Viet.a81),

        // e lowercase
        VietCode(Viet.e,   Viet.e1),
        VietCode(Viet.e1,  Viet.e,  0x31),
        VietCode(Viet.e2,  Viet.e1),
        VietCode(Viet.e3,  Viet.e1),
        VietCode(Viet.e4,  Viet.e1),
        VietCode(Viet.e5,  Viet.e1),

        VietCode(Viet.e6,  Viet.e61),
        VietCode(Viet.e61, Viet.e6, 0x31),
        VietCode(Viet.e62, Viet.e61),
        VietCode(Viet.e63, Viet.e61),
        VietCode(Viet.e64, Viet.e61),
        VietCode(Viet.e65, Viet.e61),

        // o lowercase
        VietCode(Viet.o,   Viet.o1),
        VietCode(Viet.o1,  Viet.o,  0x31),
        VietCode(Viet.o2,  Viet.o1),
        VietCode(Viet.o3,  Viet.o1),
        VietCode(Viet.o4,  Viet.o1),
        VietCode(Viet.o5,  Viet.o1),

        VietCode(Viet.o6,  Viet.o61),
        VietCode(Viet.o61, Viet.o6, 0x31),
        VietCode(Viet.o62, Viet.o61),
        VietCode(Viet.o63, Viet.o61),
        VietCode(Viet.o64, Viet.o61),
        VietCode(Viet.o65, Viet.o61),

        VietCode(Viet.o7,  Viet.o71),
        VietCode(Viet.o71, Viet.o7, 0x31),
        VietCode(Viet.o72, Viet.o71),
        VietCode(Viet.o73, Viet.o71),
        VietCode(Viet.o74, Viet.o71),
        VietCode(Viet.o75, Viet.o71),

        // u lowercase
        VietCode(Viet.u,   Viet.u1),
        VietCode(Viet.u1,  Viet.u,  0x31),
        VietCode(Viet.u2,  Viet.u1),
        VietCode(Viet.u3,  Viet.u1),
        VietCode(Viet.u4,  Viet.u1),
        VietCode(Viet.u5,  Viet.u1),

        VietCode(Viet.u7,  Viet.u71),
        VietCode(Viet.u71, Viet.u7, 0x31),
        VietCode(Viet.u72, Viet.u71),
        VietCode(Viet.u73, Viet.u71),
        VietCode(Viet.u74, Viet.u71),
        VietCode(Viet.u75, Viet.u71),

        // i lowercase
        VietCode(Viet.i,   Viet.i1),
        VietCode(Viet.i1,  Viet.i,  0x31),
        VietCode(Viet.i2,  Viet.i1),
        VietCode(Viet.i3,  Viet.i1),
        VietCode(Viet.i4,  Viet.i1),
        VietCode(Viet.i5,  Viet.i1),

        // y lowercase
        VietCode(Viet.y,   Viet.y1),
        VietCode(Viet.y1,  Viet.y,  0x31),
        VietCode(Viet.y2,  Viet.y1),
        VietCode(Viet.y3,  Viet.y1),
        VietCode(Viet.y4,  Viet.y1),
        VietCode(Viet.y5,  Viet.y1),
    ]

    // MARK: - code_2: Grave (`) via key '2'

    static let code_2: [VietCode] = [
        // A uppercase
        VietCode(Viet.A,   Viet.A2),
        VietCode(Viet.A1,  Viet.A2),
        VietCode(Viet.A2,  Viet.A,  0x32),
        VietCode(Viet.A3,  Viet.A2),
        VietCode(Viet.A4,  Viet.A2),
        VietCode(Viet.A5,  Viet.A2),

        VietCode(Viet.A6,  Viet.A62),
        VietCode(Viet.A61, Viet.A62),
        VietCode(Viet.A62, Viet.A6, 0x32),
        VietCode(Viet.A63, Viet.A62),
        VietCode(Viet.A64, Viet.A62),
        VietCode(Viet.A65, Viet.A62),

        VietCode(Viet.A8,  Viet.A82),
        VietCode(Viet.A81, Viet.A82),
        VietCode(Viet.A82, Viet.A8, 0x32),
        VietCode(Viet.A83, Viet.A82),
        VietCode(Viet.A84, Viet.A82),
        VietCode(Viet.A85, Viet.A82),

        // E uppercase
        VietCode(Viet.E,   Viet.E2),
        VietCode(Viet.E1,  Viet.E2),
        VietCode(Viet.E2,  Viet.E,  0x32),
        VietCode(Viet.E3,  Viet.E2),
        VietCode(Viet.E4,  Viet.E2),
        VietCode(Viet.E5,  Viet.E2),

        VietCode(Viet.E6,  Viet.E62),
        VietCode(Viet.E61, Viet.E62),
        VietCode(Viet.E62, Viet.E6, 0x32),
        VietCode(Viet.E63, Viet.E62),
        VietCode(Viet.E64, Viet.E62),
        VietCode(Viet.E65, Viet.E62),

        // O uppercase
        VietCode(Viet.O,   Viet.O2),
        VietCode(Viet.O1,  Viet.O2),
        VietCode(Viet.O2,  Viet.O,  0x32),
        VietCode(Viet.O3,  Viet.O2),
        VietCode(Viet.O4,  Viet.O2),
        VietCode(Viet.O5,  Viet.O2),

        VietCode(Viet.O6,  Viet.O62),
        VietCode(Viet.O61, Viet.O62),
        VietCode(Viet.O62, Viet.O6, 0x32),
        VietCode(Viet.O63, Viet.O62),
        VietCode(Viet.O64, Viet.O62),
        VietCode(Viet.O65, Viet.O62),

        VietCode(Viet.O7,  Viet.O72),
        VietCode(Viet.O71, Viet.O72),
        VietCode(Viet.O72, Viet.O7, 0x32),
        VietCode(Viet.O73, Viet.O72),
        VietCode(Viet.O74, Viet.O72),
        VietCode(Viet.O75, Viet.O72),

        // U uppercase
        VietCode(Viet.U,   Viet.U2),
        VietCode(Viet.U1,  Viet.U2),
        VietCode(Viet.U2,  Viet.U,  0x32),
        VietCode(Viet.U3,  Viet.U2),
        VietCode(Viet.U4,  Viet.U2),
        VietCode(Viet.U5,  Viet.U2),

        VietCode(Viet.U7,  Viet.U72),
        VietCode(Viet.U71, Viet.U72),
        VietCode(Viet.U72, Viet.U7, 0x32),
        VietCode(Viet.U73, Viet.U72),
        VietCode(Viet.U74, Viet.U72),
        VietCode(Viet.U75, Viet.U72),

        // I uppercase
        VietCode(Viet.I,   Viet.I2),
        VietCode(Viet.I1,  Viet.I2),
        VietCode(Viet.I2,  Viet.I,  0x32),
        VietCode(Viet.I3,  Viet.I2),
        VietCode(Viet.I4,  Viet.I2),
        VietCode(Viet.I5,  Viet.I2),

        // Y uppercase
        VietCode(Viet.Y,   Viet.Y2),
        VietCode(Viet.Y1,  Viet.Y2),
        VietCode(Viet.Y2,  Viet.Y,  0x32),
        VietCode(Viet.Y3,  Viet.Y2),
        VietCode(Viet.Y4,  Viet.Y2),
        VietCode(Viet.Y5,  Viet.Y2),

        // a lowercase
        VietCode(Viet.a,   Viet.a2),
        VietCode(Viet.a1,  Viet.a2),
        VietCode(Viet.a2,  Viet.a,  0x32),
        VietCode(Viet.a3,  Viet.a2),
        VietCode(Viet.a4,  Viet.a2),
        VietCode(Viet.a5,  Viet.a2),

        VietCode(Viet.a6,  Viet.a62),
        VietCode(Viet.a61, Viet.a62),
        VietCode(Viet.a62, Viet.a6, 0x32),
        VietCode(Viet.a63, Viet.a62),
        VietCode(Viet.a64, Viet.a62),
        VietCode(Viet.a65, Viet.a62),

        VietCode(Viet.a8,  Viet.a82),
        VietCode(Viet.a81, Viet.a82),
        VietCode(Viet.a82, Viet.a8, 0x32),
        VietCode(Viet.a83, Viet.a82),
        VietCode(Viet.a84, Viet.a82),
        VietCode(Viet.a85, Viet.a82),

        // e lowercase
        VietCode(Viet.e,   Viet.e2),
        VietCode(Viet.e1,  Viet.e2),
        VietCode(Viet.e2,  Viet.e,  0x32),
        VietCode(Viet.e3,  Viet.e2),
        VietCode(Viet.e4,  Viet.e2),
        VietCode(Viet.e5,  Viet.e2),

        VietCode(Viet.e6,  Viet.e62),
        VietCode(Viet.e61, Viet.e62),
        VietCode(Viet.e62, Viet.e6, 0x32),
        VietCode(Viet.e63, Viet.e62),
        VietCode(Viet.e64, Viet.e62),
        VietCode(Viet.e65, Viet.e62),

        // o lowercase
        VietCode(Viet.o,   Viet.o2),
        VietCode(Viet.o1,  Viet.o2),
        VietCode(Viet.o2,  Viet.o,  0x32),
        VietCode(Viet.o3,  Viet.o2),
        VietCode(Viet.o4,  Viet.o2),
        VietCode(Viet.o5,  Viet.o2),

        VietCode(Viet.o6,  Viet.o62),
        VietCode(Viet.o61, Viet.o62),
        VietCode(Viet.o62, Viet.o6, 0x32),
        VietCode(Viet.o63, Viet.o62),
        VietCode(Viet.o64, Viet.o62),
        VietCode(Viet.o65, Viet.o62),

        VietCode(Viet.o7,  Viet.o72),
        VietCode(Viet.o71, Viet.o72),
        VietCode(Viet.o72, Viet.o7, 0x32),
        VietCode(Viet.o73, Viet.o72),
        VietCode(Viet.o74, Viet.o72),
        VietCode(Viet.o75, Viet.o72),

        // u lowercase
        VietCode(Viet.u,   Viet.u2),
        VietCode(Viet.u1,  Viet.u2),
        VietCode(Viet.u2,  Viet.u,  0x32),
        VietCode(Viet.u3,  Viet.u2),
        VietCode(Viet.u4,  Viet.u2),
        VietCode(Viet.u5,  Viet.u2),

        VietCode(Viet.u7,  Viet.u72),
        VietCode(Viet.u71, Viet.u72),
        VietCode(Viet.u72, Viet.u7, 0x32),
        VietCode(Viet.u73, Viet.u72),
        VietCode(Viet.u74, Viet.u72),
        VietCode(Viet.u75, Viet.u72),

        // i lowercase
        VietCode(Viet.i,   Viet.i2),
        VietCode(Viet.i1,  Viet.i2),
        VietCode(Viet.i2,  Viet.i,  0x32),
        VietCode(Viet.i3,  Viet.i2),
        VietCode(Viet.i4,  Viet.i2),
        VietCode(Viet.i5,  Viet.i2),

        // y lowercase
        VietCode(Viet.y,   Viet.y2),
        VietCode(Viet.y1,  Viet.y2),
        VietCode(Viet.y2,  Viet.y,  0x32),
        VietCode(Viet.y3,  Viet.y2),
        VietCode(Viet.y4,  Viet.y2),
        VietCode(Viet.y5,  Viet.y2),
    ]

    // MARK: - code_3: Hook above (?) via key '3'

    static let code_3: [VietCode] = [
        // A uppercase
        VietCode(Viet.A,   Viet.A3),
        VietCode(Viet.A1,  Viet.A3),
        VietCode(Viet.A2,  Viet.A3),
        VietCode(Viet.A3,  Viet.A,  0x33),
        VietCode(Viet.A4,  Viet.A3),
        VietCode(Viet.A5,  Viet.A3),

        VietCode(Viet.A6,  Viet.A63),
        VietCode(Viet.A61, Viet.A63),
        VietCode(Viet.A62, Viet.A63),
        VietCode(Viet.A63, Viet.A6, 0x33),
        VietCode(Viet.A64, Viet.A63),
        VietCode(Viet.A65, Viet.A63),

        VietCode(Viet.A8,  Viet.A83),
        VietCode(Viet.A81, Viet.A83),
        VietCode(Viet.A82, Viet.A83),
        VietCode(Viet.A83, Viet.A8, 0x33),
        VietCode(Viet.A84, Viet.A83),
        VietCode(Viet.A85, Viet.A83),

        // E uppercase
        VietCode(Viet.E,   Viet.E3),
        VietCode(Viet.E1,  Viet.E3),
        VietCode(Viet.E2,  Viet.E3),
        VietCode(Viet.E3,  Viet.E,  0x33),
        VietCode(Viet.E4,  Viet.E3),
        VietCode(Viet.E5,  Viet.E3),

        VietCode(Viet.E6,  Viet.E63),
        VietCode(Viet.E61, Viet.E63),
        VietCode(Viet.E62, Viet.E63),
        VietCode(Viet.E63, Viet.E6, 0x33),
        VietCode(Viet.E64, Viet.E63),
        VietCode(Viet.E65, Viet.E63),

        // O uppercase
        VietCode(Viet.O,   Viet.O3),
        VietCode(Viet.O1,  Viet.O3),
        VietCode(Viet.O2,  Viet.O3),
        VietCode(Viet.O3,  Viet.O,  0x33),
        VietCode(Viet.O4,  Viet.O3),
        VietCode(Viet.O5,  Viet.O3),

        VietCode(Viet.O6,  Viet.O63),
        VietCode(Viet.O61, Viet.O63),
        VietCode(Viet.O62, Viet.O63),
        VietCode(Viet.O63, Viet.O6, 0x33),
        VietCode(Viet.O64, Viet.O63),
        VietCode(Viet.O65, Viet.O63),

        VietCode(Viet.O7,  Viet.O73),
        VietCode(Viet.O71, Viet.O73),
        VietCode(Viet.O72, Viet.O73),
        VietCode(Viet.O73, Viet.O7, 0x33),
        VietCode(Viet.O74, Viet.O73),
        VietCode(Viet.O75, Viet.O73),

        // U uppercase
        VietCode(Viet.U,   Viet.U3),
        VietCode(Viet.U1,  Viet.U3),
        VietCode(Viet.U2,  Viet.U3),
        VietCode(Viet.U3,  Viet.U,  0x33),
        VietCode(Viet.U4,  Viet.U3),
        VietCode(Viet.U5,  Viet.U3),

        VietCode(Viet.U7,  Viet.U73),
        VietCode(Viet.U71, Viet.U73),
        VietCode(Viet.U72, Viet.U73),
        VietCode(Viet.U73, Viet.U7, 0x33),
        VietCode(Viet.U74, Viet.U73),
        VietCode(Viet.U75, Viet.U73),

        // I uppercase
        VietCode(Viet.I,   Viet.I3),
        VietCode(Viet.I1,  Viet.I3),
        VietCode(Viet.I2,  Viet.I3),
        VietCode(Viet.I3,  Viet.I,  0x33),
        VietCode(Viet.I4,  Viet.I3),
        VietCode(Viet.I5,  Viet.I3),

        // Y uppercase
        VietCode(Viet.Y,   Viet.Y3),
        VietCode(Viet.Y1,  Viet.Y3),
        VietCode(Viet.Y2,  Viet.Y3),
        VietCode(Viet.Y3,  Viet.Y,  0x33),
        VietCode(Viet.Y4,  Viet.Y3),
        VietCode(Viet.Y5,  Viet.Y3),

        // a lowercase
        VietCode(Viet.a,   Viet.a3),
        VietCode(Viet.a1,  Viet.a3),
        VietCode(Viet.a2,  Viet.a3),
        VietCode(Viet.a3,  Viet.a,  0x33),
        VietCode(Viet.a4,  Viet.a3),
        VietCode(Viet.a5,  Viet.a3),

        VietCode(Viet.a6,  Viet.a63),
        VietCode(Viet.a61, Viet.a63),
        VietCode(Viet.a62, Viet.a63),
        VietCode(Viet.a63, Viet.a6, 0x33),
        VietCode(Viet.a64, Viet.a63),
        VietCode(Viet.a65, Viet.a63),

        VietCode(Viet.a8,  Viet.a83),
        VietCode(Viet.a81, Viet.a83),
        VietCode(Viet.a82, Viet.a83),
        VietCode(Viet.a83, Viet.a8, 0x33),
        VietCode(Viet.a84, Viet.a83),
        VietCode(Viet.a85, Viet.a83),

        // e lowercase
        VietCode(Viet.e,   Viet.e3),
        VietCode(Viet.e1,  Viet.e3),
        VietCode(Viet.e2,  Viet.e3),
        VietCode(Viet.e3,  Viet.e,  0x33),
        VietCode(Viet.e4,  Viet.e3),
        VietCode(Viet.e5,  Viet.e3),

        VietCode(Viet.e6,  Viet.e63),
        VietCode(Viet.e61, Viet.e63),
        VietCode(Viet.e62, Viet.e63),
        VietCode(Viet.e63, Viet.e6, 0x33),
        VietCode(Viet.e64, Viet.e63),
        VietCode(Viet.e65, Viet.e63),

        // o lowercase
        VietCode(Viet.o,   Viet.o3),
        VietCode(Viet.o1,  Viet.o3),
        VietCode(Viet.o2,  Viet.o3),
        VietCode(Viet.o3,  Viet.o,  0x33),
        VietCode(Viet.o4,  Viet.o3),
        VietCode(Viet.o5,  Viet.o3),

        VietCode(Viet.o6,  Viet.o63),
        VietCode(Viet.o61, Viet.o63),
        VietCode(Viet.o62, Viet.o63),
        VietCode(Viet.o63, Viet.o6, 0x33),
        VietCode(Viet.o64, Viet.o63),
        VietCode(Viet.o65, Viet.o63),

        VietCode(Viet.o7,  Viet.o73),
        VietCode(Viet.o71, Viet.o73),
        VietCode(Viet.o72, Viet.o73),
        VietCode(Viet.o73, Viet.o7, 0x33),
        VietCode(Viet.o74, Viet.o73),
        VietCode(Viet.o75, Viet.o73),

        // u lowercase
        VietCode(Viet.u,   Viet.u3),
        VietCode(Viet.u1,  Viet.u3),
        VietCode(Viet.u2,  Viet.u3),
        VietCode(Viet.u3,  Viet.u,  0x33),
        VietCode(Viet.u4,  Viet.u3),
        VietCode(Viet.u5,  Viet.u3),

        VietCode(Viet.u7,  Viet.u73),
        VietCode(Viet.u71, Viet.u73),
        VietCode(Viet.u72, Viet.u73),
        VietCode(Viet.u73, Viet.u7, 0x33),
        VietCode(Viet.u74, Viet.u73),
        VietCode(Viet.u75, Viet.u73),

        // i lowercase
        VietCode(Viet.i,   Viet.i3),
        VietCode(Viet.i1,  Viet.i3),
        VietCode(Viet.i2,  Viet.i3),
        VietCode(Viet.i3,  Viet.i,  0x33),
        VietCode(Viet.i4,  Viet.i3),
        VietCode(Viet.i5,  Viet.i3),

        // y lowercase
        VietCode(Viet.y,   Viet.y3),
        VietCode(Viet.y1,  Viet.y3),
        VietCode(Viet.y2,  Viet.y3),
        VietCode(Viet.y3,  Viet.y,  0x33),
        VietCode(Viet.y4,  Viet.y3),
        VietCode(Viet.y5,  Viet.y3),
    ]

    // MARK: - code_4: Tilde (~) via key '4'

    static let code_4: [VietCode] = [
        // A uppercase
        VietCode(Viet.A,   Viet.A4),
        VietCode(Viet.A1,  Viet.A4),
        VietCode(Viet.A2,  Viet.A4),
        VietCode(Viet.A3,  Viet.A4),
        VietCode(Viet.A4,  Viet.A,  0x34),
        VietCode(Viet.A5,  Viet.A4),

        VietCode(Viet.A6,  Viet.A64),
        VietCode(Viet.A61, Viet.A64),
        VietCode(Viet.A62, Viet.A64),
        VietCode(Viet.A63, Viet.A64),
        VietCode(Viet.A64, Viet.A6, 0x34),
        VietCode(Viet.A65, Viet.A64),

        VietCode(Viet.A8,  Viet.A84),
        VietCode(Viet.A81, Viet.A84),
        VietCode(Viet.A82, Viet.A84),
        VietCode(Viet.A83, Viet.A84),
        VietCode(Viet.A84, Viet.A8, 0x34),
        VietCode(Viet.A85, Viet.A84),

        // E uppercase
        VietCode(Viet.E,   Viet.E4),
        VietCode(Viet.E1,  Viet.E4),
        VietCode(Viet.E2,  Viet.E4),
        VietCode(Viet.E3,  Viet.E4),
        VietCode(Viet.E4,  Viet.E,  0x34),
        VietCode(Viet.E5,  Viet.E4),

        VietCode(Viet.E6,  Viet.E64),
        VietCode(Viet.E61, Viet.E64),
        VietCode(Viet.E62, Viet.E64),
        VietCode(Viet.E63, Viet.E64),
        VietCode(Viet.E64, Viet.E6, 0x34),
        VietCode(Viet.E65, Viet.E64),

        // O uppercase
        VietCode(Viet.O,   Viet.O4),
        VietCode(Viet.O1,  Viet.O4),
        VietCode(Viet.O2,  Viet.O4),
        VietCode(Viet.O3,  Viet.O4),
        VietCode(Viet.O4,  Viet.O,  0x34),
        VietCode(Viet.O5,  Viet.O4),

        VietCode(Viet.O6,  Viet.O64),
        VietCode(Viet.O61, Viet.O64),
        VietCode(Viet.O62, Viet.O64),
        VietCode(Viet.O63, Viet.O64),
        VietCode(Viet.O64, Viet.O6, 0x34),
        VietCode(Viet.O65, Viet.O64),

        VietCode(Viet.O7,  Viet.O74),
        VietCode(Viet.O71, Viet.O74),
        VietCode(Viet.O72, Viet.O74),
        VietCode(Viet.O73, Viet.O74),
        VietCode(Viet.O74, Viet.O7, 0x34),
        VietCode(Viet.O75, Viet.O74),

        // U uppercase
        VietCode(Viet.U,   Viet.U4),
        VietCode(Viet.U1,  Viet.U4),
        VietCode(Viet.U2,  Viet.U4),
        VietCode(Viet.U3,  Viet.U4),
        VietCode(Viet.U4,  Viet.U,  0x34),
        VietCode(Viet.U5,  Viet.U4),

        VietCode(Viet.U7,  Viet.U74),
        VietCode(Viet.U71, Viet.U74),
        VietCode(Viet.U72, Viet.U74),
        VietCode(Viet.U73, Viet.U74),
        VietCode(Viet.U74, Viet.U7, 0x34),
        VietCode(Viet.U75, Viet.U74),

        // I uppercase
        VietCode(Viet.I,   Viet.I4),
        VietCode(Viet.I1,  Viet.I4),
        VietCode(Viet.I2,  Viet.I4),
        VietCode(Viet.I3,  Viet.I4),
        VietCode(Viet.I4,  Viet.I,  0x34),
        VietCode(Viet.I5,  Viet.I4),

        // Y uppercase
        VietCode(Viet.Y,   Viet.Y4),
        VietCode(Viet.Y1,  Viet.Y4),
        VietCode(Viet.Y2,  Viet.Y4),
        VietCode(Viet.Y3,  Viet.Y4),
        VietCode(Viet.Y4,  Viet.Y,  0x34),
        VietCode(Viet.Y5,  Viet.Y4),

        // a lowercase
        VietCode(Viet.a,   Viet.a4),
        VietCode(Viet.a1,  Viet.a4),
        VietCode(Viet.a2,  Viet.a4),
        VietCode(Viet.a3,  Viet.a4),
        VietCode(Viet.a4,  Viet.a,  0x34),
        VietCode(Viet.a5,  Viet.a4),

        VietCode(Viet.a6,  Viet.a64),
        VietCode(Viet.a61, Viet.a64),
        VietCode(Viet.a62, Viet.a64),
        VietCode(Viet.a63, Viet.a64),
        VietCode(Viet.a64, Viet.a6, 0x34),
        VietCode(Viet.a65, Viet.a64),

        VietCode(Viet.a8,  Viet.a84),
        VietCode(Viet.a81, Viet.a84),
        VietCode(Viet.a82, Viet.a84),
        VietCode(Viet.a83, Viet.a84),
        VietCode(Viet.a84, Viet.a8, 0x34),
        VietCode(Viet.a85, Viet.a84),

        // e lowercase
        VietCode(Viet.e,   Viet.e4),
        VietCode(Viet.e1,  Viet.e4),
        VietCode(Viet.e2,  Viet.e4),
        VietCode(Viet.e3,  Viet.e4),
        VietCode(Viet.e4,  Viet.e,  0x34),
        VietCode(Viet.e5,  Viet.e4),

        VietCode(Viet.e6,  Viet.e64),
        VietCode(Viet.e61, Viet.e64),
        VietCode(Viet.e62, Viet.e64),
        VietCode(Viet.e63, Viet.e64),
        VietCode(Viet.e64, Viet.e6, 0x34),
        VietCode(Viet.e65, Viet.e64),

        // o lowercase
        VietCode(Viet.o,   Viet.o4),
        VietCode(Viet.o1,  Viet.o4),
        VietCode(Viet.o2,  Viet.o4),
        VietCode(Viet.o3,  Viet.o4),
        VietCode(Viet.o4,  Viet.o,  0x34),
        VietCode(Viet.o5,  Viet.o4),

        VietCode(Viet.o6,  Viet.o64),
        VietCode(Viet.o61, Viet.o64),
        VietCode(Viet.o62, Viet.o64),
        VietCode(Viet.o63, Viet.o64),
        VietCode(Viet.o64, Viet.o6, 0x34),
        VietCode(Viet.o65, Viet.o64),

        VietCode(Viet.o7,  Viet.o74),
        VietCode(Viet.o71, Viet.o74),
        VietCode(Viet.o72, Viet.o74),
        VietCode(Viet.o73, Viet.o74),
        VietCode(Viet.o74, Viet.o7, 0x34),
        VietCode(Viet.o75, Viet.o74),

        // u lowercase
        VietCode(Viet.u,   Viet.u4),
        VietCode(Viet.u1,  Viet.u4),
        VietCode(Viet.u2,  Viet.u4),
        VietCode(Viet.u3,  Viet.u4),
        VietCode(Viet.u4,  Viet.u,  0x34),
        VietCode(Viet.u5,  Viet.u4),

        VietCode(Viet.u7,  Viet.u74),
        VietCode(Viet.u71, Viet.u74),
        VietCode(Viet.u72, Viet.u74),
        VietCode(Viet.u73, Viet.u74),
        VietCode(Viet.u74, Viet.u7, 0x34),
        VietCode(Viet.u75, Viet.u74),

        // i lowercase
        VietCode(Viet.i,   Viet.i4),
        VietCode(Viet.i1,  Viet.i4),
        VietCode(Viet.i2,  Viet.i4),
        VietCode(Viet.i3,  Viet.i4),
        VietCode(Viet.i4,  Viet.i,  0x34),
        VietCode(Viet.i5,  Viet.i4),

        // y lowercase
        VietCode(Viet.y,   Viet.y4),
        VietCode(Viet.y1,  Viet.y4),
        VietCode(Viet.y2,  Viet.y4),
        VietCode(Viet.y3,  Viet.y4),
        VietCode(Viet.y4,  Viet.y,  0x34),
        VietCode(Viet.y5,  Viet.y4),
    ]

    // MARK: - code_5: Dot below (.) via key '5'

    static let code_5: [VietCode] = [
        // A uppercase
        VietCode(Viet.A,   Viet.A5),
        VietCode(Viet.A1,  Viet.A5),
        VietCode(Viet.A2,  Viet.A5),
        VietCode(Viet.A3,  Viet.A5),
        VietCode(Viet.A4,  Viet.A5),
        VietCode(Viet.A5,  Viet.A,  0x35),

        VietCode(Viet.A6,  Viet.A65),
        VietCode(Viet.A61, Viet.A65),
        VietCode(Viet.A62, Viet.A65),
        VietCode(Viet.A63, Viet.A65),
        VietCode(Viet.A64, Viet.A65),
        VietCode(Viet.A65, Viet.A6, 0x35),

        VietCode(Viet.A8,  Viet.A85),
        VietCode(Viet.A81, Viet.A85),
        VietCode(Viet.A82, Viet.A85),
        VietCode(Viet.A83, Viet.A85),
        VietCode(Viet.A84, Viet.A85),
        VietCode(Viet.A85, Viet.A8, 0x35),

        // E uppercase
        VietCode(Viet.E,   Viet.E5),
        VietCode(Viet.E1,  Viet.E5),
        VietCode(Viet.E2,  Viet.E5),
        VietCode(Viet.E3,  Viet.E5),
        VietCode(Viet.E4,  Viet.E5),
        VietCode(Viet.E5,  Viet.E,  0x35),

        VietCode(Viet.E6,  Viet.E65),
        VietCode(Viet.E61, Viet.E65),
        VietCode(Viet.E62, Viet.E65),
        VietCode(Viet.E63, Viet.E65),
        VietCode(Viet.E64, Viet.E65),
        VietCode(Viet.E65, Viet.E6, 0x35),

        // O uppercase
        VietCode(Viet.O,   Viet.O5),
        VietCode(Viet.O1,  Viet.O5),
        VietCode(Viet.O2,  Viet.O5),
        VietCode(Viet.O3,  Viet.O5),
        VietCode(Viet.O4,  Viet.O5),
        VietCode(Viet.O5,  Viet.O,  0x35),

        VietCode(Viet.O6,  Viet.O65),
        VietCode(Viet.O61, Viet.O65),
        VietCode(Viet.O62, Viet.O65),
        VietCode(Viet.O63, Viet.O65),
        VietCode(Viet.O64, Viet.O65),
        VietCode(Viet.O65, Viet.O6, 0x35),

        VietCode(Viet.O7,  Viet.O75),
        VietCode(Viet.O71, Viet.O75),
        VietCode(Viet.O72, Viet.O75),
        VietCode(Viet.O73, Viet.O75),
        VietCode(Viet.O74, Viet.O75),
        VietCode(Viet.O75, Viet.O7, 0x35),

        // U uppercase
        VietCode(Viet.U,   Viet.U5),
        VietCode(Viet.U1,  Viet.U5),
        VietCode(Viet.U2,  Viet.U5),
        VietCode(Viet.U3,  Viet.U5),
        VietCode(Viet.U4,  Viet.U5),
        VietCode(Viet.U5,  Viet.U,  0x35),

        VietCode(Viet.U7,  Viet.U75),
        VietCode(Viet.U71, Viet.U75),
        VietCode(Viet.U72, Viet.U75),
        VietCode(Viet.U73, Viet.U75),
        VietCode(Viet.U74, Viet.U75),
        VietCode(Viet.U75, Viet.U7, 0x35),

        // I uppercase
        VietCode(Viet.I,   Viet.I5),
        VietCode(Viet.I1,  Viet.I5),
        VietCode(Viet.I2,  Viet.I5),
        VietCode(Viet.I3,  Viet.I5),
        VietCode(Viet.I4,  Viet.I5),
        VietCode(Viet.I5,  Viet.I,  0x35),

        // Y uppercase
        VietCode(Viet.Y,   Viet.Y5),
        VietCode(Viet.Y1,  Viet.Y5),
        VietCode(Viet.Y2,  Viet.Y5),
        VietCode(Viet.Y3,  Viet.Y5),
        VietCode(Viet.Y4,  Viet.Y5),
        VietCode(Viet.Y5,  Viet.Y,  0x35),

        // a lowercase
        VietCode(Viet.a,   Viet.a5),
        VietCode(Viet.a1,  Viet.a5),
        VietCode(Viet.a2,  Viet.a5),
        VietCode(Viet.a3,  Viet.a5),
        VietCode(Viet.a4,  Viet.a5),
        VietCode(Viet.a5,  Viet.a,  0x35),

        VietCode(Viet.a6,  Viet.a65),
        VietCode(Viet.a61, Viet.a65),
        VietCode(Viet.a62, Viet.a65),
        VietCode(Viet.a63, Viet.a65),
        VietCode(Viet.a64, Viet.a65),
        VietCode(Viet.a65, Viet.a6, 0x35),

        VietCode(Viet.a8,  Viet.a85),
        VietCode(Viet.a81, Viet.a85),
        VietCode(Viet.a82, Viet.a85),
        VietCode(Viet.a83, Viet.a85),
        VietCode(Viet.a84, Viet.a85),
        VietCode(Viet.a85, Viet.a8, 0x35),

        // e lowercase
        VietCode(Viet.e,   Viet.e5),
        VietCode(Viet.e1,  Viet.e5),
        VietCode(Viet.e2,  Viet.e5),
        VietCode(Viet.e3,  Viet.e5),
        VietCode(Viet.e4,  Viet.e5),
        VietCode(Viet.e5,  Viet.e,  0x35),

        VietCode(Viet.e6,  Viet.e65),
        VietCode(Viet.e61, Viet.e65),
        VietCode(Viet.e62, Viet.e65),
        VietCode(Viet.e63, Viet.e65),
        VietCode(Viet.e64, Viet.e65),
        VietCode(Viet.e65, Viet.e6, 0x35),

        // o lowercase
        VietCode(Viet.o,   Viet.o5),
        VietCode(Viet.o1,  Viet.o5),
        VietCode(Viet.o2,  Viet.o5),
        VietCode(Viet.o3,  Viet.o5),
        VietCode(Viet.o4,  Viet.o5),
        VietCode(Viet.o5,  Viet.o,  0x35),

        VietCode(Viet.o6,  Viet.o65),
        VietCode(Viet.o61, Viet.o65),
        VietCode(Viet.o62, Viet.o65),
        VietCode(Viet.o63, Viet.o65),
        VietCode(Viet.o64, Viet.o65),
        VietCode(Viet.o65, Viet.o6, 0x35),

        VietCode(Viet.o7,  Viet.o75),
        VietCode(Viet.o71, Viet.o75),
        VietCode(Viet.o72, Viet.o75),
        VietCode(Viet.o73, Viet.o75),
        VietCode(Viet.o74, Viet.o75),
        VietCode(Viet.o75, Viet.o7, 0x35),

        // u lowercase
        VietCode(Viet.u,   Viet.u5),
        VietCode(Viet.u1,  Viet.u5),
        VietCode(Viet.u2,  Viet.u5),
        VietCode(Viet.u3,  Viet.u5),
        VietCode(Viet.u4,  Viet.u5),
        VietCode(Viet.u5,  Viet.u,  0x35),

        VietCode(Viet.u7,  Viet.u75),
        VietCode(Viet.u71, Viet.u75),
        VietCode(Viet.u72, Viet.u75),
        VietCode(Viet.u73, Viet.u75),
        VietCode(Viet.u74, Viet.u75),
        VietCode(Viet.u75, Viet.u7, 0x35),

        // i lowercase
        VietCode(Viet.i,   Viet.i5),
        VietCode(Viet.i1,  Viet.i5),
        VietCode(Viet.i2,  Viet.i5),
        VietCode(Viet.i3,  Viet.i5),
        VietCode(Viet.i4,  Viet.i5),
        VietCode(Viet.i5,  Viet.i,  0x35),

        // y lowercase
        VietCode(Viet.y,   Viet.y5),
        VietCode(Viet.y1,  Viet.y5),
        VietCode(Viet.y2,  Viet.y5),
        VietCode(Viet.y3,  Viet.y5),
        VietCode(Viet.y4,  Viet.y5),
        VietCode(Viet.y5,  Viet.y,  0x35),
    ]
}
