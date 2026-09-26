//
//  SharedRules.swift
//  NAKL
//
//  Ported from utf.h (shared rule arrays used by both Telex and VNI)
//  Original copyright (C) 2002 by Dao Hai Lam, VISC Software & Security Consultant Company
//  Licensed under the GNU General Public License v2 or later.
//

import Foundation

// VietCode struct is defined in TelexRules.swift -- reuse it here.
// Modifier struct is defined in ModifierMaps.swift -- reuse it here.

enum SharedRules {

    // MARK: - code_z: Remove all tone marks (undo key)

    static let code_z: [VietCode] = [
        // A uppercase
        VietCode(Viet.A1,  Viet.A),
        VietCode(Viet.A2,  Viet.A),
        VietCode(Viet.A3,  Viet.A),
        VietCode(Viet.A4,  Viet.A),
        VietCode(Viet.A5,  Viet.A),

        VietCode(Viet.A61, Viet.A6),
        VietCode(Viet.A62, Viet.A6),
        VietCode(Viet.A63, Viet.A6),
        VietCode(Viet.A64, Viet.A6),
        VietCode(Viet.A65, Viet.A6),

        VietCode(Viet.A81, Viet.A8),
        VietCode(Viet.A82, Viet.A8),
        VietCode(Viet.A83, Viet.A8),
        VietCode(Viet.A84, Viet.A8),
        VietCode(Viet.A85, Viet.A8),

        // E uppercase
        VietCode(Viet.E1,  Viet.E),
        VietCode(Viet.E2,  Viet.E),
        VietCode(Viet.E3,  Viet.E),
        VietCode(Viet.E4,  Viet.E),
        VietCode(Viet.E5,  Viet.E),

        VietCode(Viet.E61, Viet.E6),
        VietCode(Viet.E62, Viet.E6),
        VietCode(Viet.E63, Viet.E6),
        VietCode(Viet.E64, Viet.E6),
        VietCode(Viet.E65, Viet.E6),

        // O uppercase
        VietCode(Viet.O1,  Viet.O),
        VietCode(Viet.O2,  Viet.O),
        VietCode(Viet.O3,  Viet.O),
        VietCode(Viet.O4,  Viet.O),
        VietCode(Viet.O5,  Viet.O),

        VietCode(Viet.O61, Viet.O6),
        VietCode(Viet.O62, Viet.O6),
        VietCode(Viet.O63, Viet.O6),
        VietCode(Viet.O64, Viet.O6),
        VietCode(Viet.O65, Viet.O6),

        VietCode(Viet.O71, Viet.O7),
        VietCode(Viet.O72, Viet.O7),
        VietCode(Viet.O73, Viet.O7),
        VietCode(Viet.O74, Viet.O7),
        VietCode(Viet.O75, Viet.O7),

        // U uppercase
        VietCode(Viet.U1,  Viet.U),
        VietCode(Viet.U2,  Viet.U),
        VietCode(Viet.U3,  Viet.U),
        VietCode(Viet.U4,  Viet.U),
        VietCode(Viet.U5,  Viet.U),

        VietCode(Viet.U71, Viet.U7),
        VietCode(Viet.U72, Viet.U7),
        VietCode(Viet.U73, Viet.U7),
        VietCode(Viet.U74, Viet.U7),
        VietCode(Viet.U75, Viet.U7),

        // I uppercase
        VietCode(Viet.I1,  Viet.I),
        VietCode(Viet.I2,  Viet.I),
        VietCode(Viet.I3,  Viet.I),
        VietCode(Viet.I4,  Viet.I),
        VietCode(Viet.I5,  Viet.I),

        // Y uppercase
        VietCode(Viet.Y1,  Viet.Y),
        VietCode(Viet.Y2,  Viet.Y),
        VietCode(Viet.Y3,  Viet.Y),
        VietCode(Viet.Y4,  Viet.Y),
        VietCode(Viet.Y5,  Viet.Y),

        // a lowercase
        VietCode(Viet.a1,  Viet.a),
        VietCode(Viet.a2,  Viet.a),
        VietCode(Viet.a3,  Viet.a),
        VietCode(Viet.a4,  Viet.a),
        VietCode(Viet.a5,  Viet.a),

        VietCode(Viet.a61, Viet.a6),
        VietCode(Viet.a62, Viet.a6),
        VietCode(Viet.a63, Viet.a6),
        VietCode(Viet.a64, Viet.a6),
        VietCode(Viet.a65, Viet.a6),

        VietCode(Viet.a81, Viet.a8),
        VietCode(Viet.a82, Viet.a8),
        VietCode(Viet.a83, Viet.a8),
        VietCode(Viet.a84, Viet.a8),
        VietCode(Viet.a85, Viet.a8),

        // e lowercase
        VietCode(Viet.e1,  Viet.e),
        VietCode(Viet.e2,  Viet.e),
        VietCode(Viet.e3,  Viet.e),
        VietCode(Viet.e4,  Viet.e),
        VietCode(Viet.e5,  Viet.e),

        VietCode(Viet.e61, Viet.e6),
        VietCode(Viet.e62, Viet.e6),
        VietCode(Viet.e63, Viet.e6),
        VietCode(Viet.e64, Viet.e6),
        VietCode(Viet.e65, Viet.e6),

        // o lowercase
        VietCode(Viet.o1,  Viet.o),
        VietCode(Viet.o2,  Viet.o),
        VietCode(Viet.o3,  Viet.o),
        VietCode(Viet.o4,  Viet.o),
        VietCode(Viet.o5,  Viet.o),

        VietCode(Viet.o61, Viet.o6),
        VietCode(Viet.o62, Viet.o6),
        VietCode(Viet.o63, Viet.o6),
        VietCode(Viet.o64, Viet.o6),
        VietCode(Viet.o65, Viet.o6),

        VietCode(Viet.o71, Viet.o7),
        VietCode(Viet.o72, Viet.o7),
        VietCode(Viet.o73, Viet.o7),
        VietCode(Viet.o74, Viet.o7),
        VietCode(Viet.o75, Viet.o7),

        // u lowercase
        VietCode(Viet.u1,  Viet.u),
        VietCode(Viet.u2,  Viet.u),
        VietCode(Viet.u3,  Viet.u),
        VietCode(Viet.u4,  Viet.u),
        VietCode(Viet.u5,  Viet.u),

        VietCode(Viet.u71, Viet.u7),
        VietCode(Viet.u72, Viet.u7),
        VietCode(Viet.u73, Viet.u7),
        VietCode(Viet.u74, Viet.u7),
        VietCode(Viet.u75, Viet.u7),

        // i lowercase
        VietCode(Viet.i1,  Viet.i),
        VietCode(Viet.i2,  Viet.i),
        VietCode(Viet.i3,  Viet.i),
        VietCode(Viet.i4,  Viet.i),
        VietCode(Viet.i5,  Viet.i),

        // y lowercase
        VietCode(Viet.y1,  Viet.y),
        VietCode(Viet.y2,  Viet.y),
        VietCode(Viet.y3,  Viet.y),
        VietCode(Viet.y4,  Viet.y),
        VietCode(Viet.y5,  Viet.y),
    ]

    // MARK: - code_sign: VND currency sign toggle

    static let code_sign: [VietCode] = [
        VietCode(Viet.d9,  Viet.vnd),          // dd => VND sign
        VietCode(Viet.vnd, Viet.d9),           // VND sign => dd
    ]

}
