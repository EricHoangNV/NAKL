import Foundation
import os

final class VietnameseEngine: @unchecked Sendable {

    static let wordSize = 32
    static let backspaceBuffer = 20

    private let lock = OSAllocatedUnfairLock()

    private var _kbBuffer: [UInt16] = {
        var buf = [UInt16](repeating: 0x08, count: 256)
        return buf
    }()

    private(set) var kbBLength: Int = 0
    private(set) var kbPLength: Int = 0
    var inputMethod: InputMethod = .telex

    private var word = [UInt16](repeating: 0, count: wordSize)
    private var backup = [UInt16](repeating: 0, count: wordSize)
    private var count: Int = 0
    private var kbOff: Int = 0

    private var vp: Int = -1
    private var vpc: Int = 0
    private var vps = [Int](repeating: 0, count: wordSize)
    private var lvs = [CChar](repeating: 0, count: wordSize)
    private var tempoff: Int = 0
    private var hasVowel: Bool = false
    private var hasSpaceBar: Bool = false

    private static let vowels: Set<CChar> = {
        Set("AIUEOYaiueoy".utf8.map { CChar($0) })
    }()

    private static let vowelsString = "AIUEOYaiueoy"

    private static let consonants: Set<CChar> = {
        Set("BCDFGHJKLMNPQRSTVWXZbcdfghjklmnpqrstvwxz".utf8.map { CChar($0) })
    }()

    private static let spchk = "AIUEOYaiueoy|BDFJKLQSVWXZbdfjklqsvwxz|'`~?.^*+="
    private static let vwchk = "|ia|ua|oa|ai|ui|oi|au|iu|eu|ie|ue|oe|ye|ao|uo|eo|ay|uy|uu|ou|io|"

    var vowelsMap: [[UInt16]] = []

    init() {
        vowelsMap = [
            Self.makeGroup([
                Viet.a, Viet.a1, Viet.a2, Viet.a3, Viet.a4, Viet.a5,
                Viet.a6, Viet.a61, Viet.a62, Viet.a63, Viet.a64, Viet.a65,
                Viet.a8, Viet.a81, Viet.a82, Viet.a83, Viet.a84, Viet.a85,
                Viet.A, Viet.A1, Viet.A2, Viet.A3, Viet.A4, Viet.A5,
                Viet.A6, Viet.A61, Viet.A62, Viet.A63, Viet.A64, Viet.A65,
                Viet.A8, Viet.A81, Viet.A82, Viet.A83, Viet.A84, Viet.A85,
            ]),
            Self.makeGroup([
                Viet.e, Viet.e1, Viet.e2, Viet.e3, Viet.e4, Viet.e5,
                Viet.e6, Viet.e61, Viet.e62, Viet.e63, Viet.e64, Viet.e65,
                Viet.E, Viet.E1, Viet.E2, Viet.E3, Viet.E4, Viet.E5,
                Viet.E6, Viet.E61, Viet.E62, Viet.E63, Viet.E64, Viet.E65,
            ]),
            Self.makeGroup([
                Viet.i, Viet.i1, Viet.i2, Viet.i3, Viet.i4, Viet.i5,
                Viet.I, Viet.I1, Viet.I2, Viet.I3, Viet.I4, Viet.I5,
            ]),
            Self.makeGroup([
                Viet.o, Viet.o1, Viet.o2, Viet.o3, Viet.o4, Viet.o5,
                Viet.o6, Viet.o61, Viet.o62, Viet.o63, Viet.o64, Viet.o65,
                Viet.o7, Viet.o71, Viet.o72, Viet.o73, Viet.o74, Viet.o75,
                Viet.O, Viet.O1, Viet.O2, Viet.O3, Viet.O4, Viet.O5,
                Viet.O6, Viet.O61, Viet.O62, Viet.O63, Viet.O64, Viet.O65,
                Viet.O7, Viet.O71, Viet.O72, Viet.O73, Viet.O74, Viet.O75,
            ]),
            Self.makeGroup([
                Viet.u, Viet.u1, Viet.u2, Viet.u3, Viet.u4, Viet.u5,
                Viet.u7, Viet.u71, Viet.u72, Viet.u73, Viet.u74, Viet.u75,
                Viet.U, Viet.U1, Viet.U2, Viet.U3, Viet.U4, Viet.U5,
                Viet.U7, Viet.U71, Viet.U72, Viet.U73, Viet.U74, Viet.U75,
            ]),
            Self.makeGroup([
                Viet.y, Viet.y1, Viet.y2, Viet.y3, Viet.y4, Viet.y5,
                Viet.Y, Viet.Y1, Viet.Y2, Viet.Y3, Viet.Y4, Viet.Y5,
            ]),
            Self.makeGroup([
                Viet.d, Viet.D, Viet.d9, Viet.D9, Viet.vnd,
            ]),
        ]
    }

    private static func makeGroup(_ chars: [UInt16]) -> [UInt16] {
        return chars
    }

    var bufferPointer: UnsafeBufferPointer<UInt16> {
        _kbBuffer.withUnsafeBufferPointer { $0 }
    }

    func getOutputSlice() -> (pointer: [UInt16], backspaceCount: Int, outputLength: Int) {
        lock.withLock {
            let start = Self.backspaceBuffer - kbPLength
            let length = kbBLength + kbPLength
            let slice = Array(_kbBuffer[start..<(start + length)])
            return (slice, kbPLength, kbBLength)
        }
    }

    // MARK: - Core Engine

    func addKeyThreadSafe(_ key: UniChar) -> Int {
        lock.withLock {
            addKey(key)
        }
    }

    func clearBufferThreadSafe() {
        lock.withLock {
            clearBuffer()
        }
    }

    func addKey(_ key: UniChar) -> Int {
        if key == KeyCode.spaceBar {
            var p = -1
            if hasSpaceBar {
                p = checkShortcut()
            }
            clearBuffer()
            hasSpaceBar = true
            return p
        }

        var p = -1
        var c: UInt16 = 0

        guard inputMethod != .off else { return -1 }

        let m = ModifierMaps.modes[inputMethod.rawValue - 1]

        var v: [VietCode]? = nil

        if count == 0 || tempoff != 0 {
            append(lastKey: c, key: key)
            return -1
        }

        p = count - 1
        c = word[p]

        for i in 0..<m.count {
            if key == m[i].modifier {
                v = m[i].code
            }
        }

        guard let v = v else {
            append(lastKey: c, key: key)
            return -1
        }

        var i = p

        while i >= 0 && !isValidModifier(word[i], key: CChar(key & 0xFF)) {
            i -= 1
        }

        if i < 0 {
            append(lastKey: c, key: key)
            return -1
        }

        while i - 1 >= 0
            && (Self.vowelsString.utf8.contains(UInt8(word[i-1] & 0xFF)) || word[i-1] > 0x80)
            && utfVnCmp(word[i-1], word[i]) < 0
            && isValidModifier(word[i-1], key: CChar(key & 0xFF))
        {
            i -= 1
        }

        if i == count - 1, i - 1 >= 0 {
            let ug = uiGroup(word[i-1])
            if ug > 0 {
                switch word[i] {
                case 0x61, 0x41: // 'a', 'A'
                    if (i - 2 < 0 || (
                        (ug < 24 && word[i-2] != 0x71 && word[i-2] != 0x51) ||
                        (ug > 24 && word[i-2] != 0x67 && word[i-2] != 0x47)
                    )) && isValidModifier(word[i-1], key: CChar(key & 0xFF)) {
                        i = i - 1
                    }
                case 0x75, 0x55: // 'u', 'U'
                    if i - 2 < 0 || (word[i-2] != 0x67 && word[i-2] != 0x47) {
                        i = i - 1
                    }
                default:
                    break
                }
            }
        }

        if p - i >= Self.backspaceBuffer {
            append(lastKey: c, key: key)
            return -1
        }

        p = i
        c = word[p]

        var codeIndex = 0
        while codeIndex < v.count && v[codeIndex].c != c {
            codeIndex += 1
        }

        if codeIndex >= v.count {
            append(lastKey: c, key: key)
            return -1
        }

        kbPLength = count - p
        if v[codeIndex].r2 == 0 {
            word[p] = v[codeIndex].r1
            backup[p] = c
        } else {
            tempoff = count
            word[count] = UInt16(key)
            count += 1
            word[p] = backup[p]
        }

        mapToCharset(&word, offset: p, length: count - p)
        return p
    }

    func clearBuffer() {
        tempoff = 0
        count = 0
        word[0] = 0
        hasVowel = false
        hasSpaceBar = false
        vp = -1
        vpc = 0
    }

    func shiftBuffer() {
        kbOff = 0
        word[0] = word[count - 1]
        count = 1
    }

    // MARK: - Private Methods

    private func mapToCharset(_ w: inout [UInt16], offset: Int, length: Int) {
        var sIndex = Self.backspaceBuffer
        for idx in offset..<(offset + length) {
            _kbBuffer[sIndex] = w[idx]
            sIndex += 1
        }
        _kbBuffer[sIndex] = 0
        kbBLength = sIndex - Self.backspaceBuffer
    }

    func uiGroup(_ u: UInt16) -> Int {
        let ui: [UInt16] = [
            Viet.U, Viet.U1, Viet.U2, Viet.U3, Viet.U4, Viet.U5,
            Viet.u, Viet.u1, Viet.u2, Viet.u3, Viet.u4, Viet.u5,
            Viet.U7, Viet.U71, Viet.U72, Viet.U73, Viet.U74, Viet.U75,
            Viet.u7, Viet.u71, Viet.u72, Viet.u73, Viet.u74, Viet.u75,
            Viet.I, Viet.I1, Viet.I2, Viet.I3, Viet.I4, Viet.I5,
            Viet.i, Viet.i1, Viet.i2, Viet.i3, Viet.i4, Viet.i5,
        ]
        for idx in 0..<ui.count {
            if u == ui[idx] {
                return idx + 1
            }
        }
        return 0
    }

    func utfVnCmp(_ u1: UInt16, _ u2: UInt16) -> Int {
        let v: [UInt16] = [
            Viet.a, Viet.A, Viet.a1, Viet.A1, Viet.a2, Viet.A2,
            Viet.a3, Viet.A3, Viet.a4, Viet.A4, Viet.a5, Viet.A5,
            Viet.a6, Viet.A6, Viet.a61, Viet.A61, Viet.a62, Viet.A62,
            Viet.a63, Viet.A63, Viet.a64, Viet.A64, Viet.a65, Viet.A65,
            Viet.a8, Viet.A8, Viet.a81, Viet.A81, Viet.a82, Viet.A82,
            Viet.a83, Viet.A83, Viet.a84, Viet.A84, Viet.a85, Viet.A85,
            Viet.e, Viet.E, Viet.e1, Viet.E1, Viet.e2, Viet.E2,
            Viet.e3, Viet.E3, Viet.e4, Viet.E4, Viet.e5, Viet.E5,
            Viet.e6, Viet.E6, Viet.e61, Viet.E61, Viet.e62, Viet.E62,
            Viet.e63, Viet.E63, Viet.e64, Viet.E64, Viet.e65, Viet.E65,
            Viet.o, Viet.O, Viet.o1, Viet.O1, Viet.o2, Viet.O2,
            Viet.o3, Viet.O3, Viet.o4, Viet.O4, Viet.o5, Viet.O5,
            Viet.o6, Viet.O6, Viet.o61, Viet.O61, Viet.o62, Viet.O62,
            Viet.o63, Viet.O63, Viet.o64, Viet.O64, Viet.o65, Viet.O65,
            Viet.o7, Viet.O7, Viet.o71, Viet.O71, Viet.o72, Viet.O72,
            Viet.o73, Viet.O73, Viet.o74, Viet.O74, Viet.o75, Viet.O75,
            Viet.y, Viet.Y, Viet.y1, Viet.Y1, Viet.y2, Viet.Y2,
            Viet.y3, Viet.Y3, Viet.y4, Viet.Y4, Viet.y5, Viet.Y5,
            Viet.u, Viet.U, Viet.u1, Viet.U1, Viet.u2, Viet.U2,
            Viet.u3, Viet.U3, Viet.u4, Viet.U4, Viet.u5, Viet.U5,
            Viet.u7, Viet.U7, Viet.u71, Viet.U71, Viet.u72, Viet.U72,
            Viet.u73, Viet.U73, Viet.u74, Viet.U74, Viet.u75, Viet.U75,
            Viet.i, Viet.I, Viet.i1, Viet.I1, Viet.i2, Viet.I2,
            Viet.i3, Viet.I3, Viet.i4, Viet.I4, Viet.i5, Viet.I5,
            Viet.d9, Viet.D9,
        ]

        var i = -1
        var jj = -1

        if let idx = v.firstIndex(of: u1) {
            i = idx
        }
        if let idx = v.firstIndex(of: u2) {
            jj = idx
        }

        return i - jj
    }

    func append(lastKey: UInt16, key: UniChar) {
        let keyChar = CChar(key & 0x7F)
        let spchkBytes = Array(Self.spchk.utf8.map { CChar($0) })

        let kp: Int
        if let idx = spchkBytes.firstIndex(of: keyChar) {
            kp = idx
        } else {
            kp = -1
        }

        if count == 0 {
            if kp >= 0 && kp < 12 {
                vpc = 1
                vp = 0
                vps[0] = -1
                lvs[0] = keyChar
            } else {
                if kp == 12 || kp > 37 {
                    return
                } else {
                    vp = -1
                    vpc = 0
                }
            }
        } else {
            if kp == 12 || kp > 37 {
                clearBuffer()
                return
            } else if kp > 12 {
                tempoff = count
            } else if kp >= 0 {
                if !hasVowel {
                    hasVowel = true
                } else {
                    let lastKeyChar = CChar(lastKey & 0x7F)
                    if let lspIdx = spchkBytes.firstIndex(of: lastKeyChar) {
                        let lkp = lspIdx
                        if lastKey < 127 && lkp > 12 && lkp < 37 {
                            tempoff = count
                        }
                    }
                }
                if vp < 0 {
                    vps[vpc] = vp
                    vpc += 1
                    vp = count
                    lvs[0] = keyChar
                } else if count - vp > 1 {
                    tempoff = count
                } else {
                    let prevChar = lvs[vpc - 1]
                    let curChar = keyChar
                    let lowerPrev = (prevChar >= 0x41 && prevChar <= 0x5A) ? prevChar + 32 : prevChar
                    let lowerCur = (curChar >= 0x41 && curChar <= 0x5A) ? curChar + 32 : curChar

                    let needle = "|\(Character(UnicodeScalar(UInt8(lowerPrev))))\(Character(UnicodeScalar(UInt8(lowerCur))))|"
                    if !Self.vwchk.contains(needle) {
                        tempoff = count
                    } else {
                        lvs[vpc] = keyChar
                        vps[vpc] = vp
                        vpc += 1
                        vp = count
                    }
                }
            } else {
                switch key {
                case 0x68, 0x48: // 'h', 'H' — [cgknpt]h
                    if lastKey > 127 || !"CGKNPTcgknpt".utf8.contains(UInt8(lastKey & 0xFF)) {
                        tempoff = count
                    }
                case 0x67, 0x47: // 'g', 'G' — [n]g
                    if lastKey != 0x6E && lastKey != 0x4E {
                        tempoff = count
                    }
                case 0x72, 0x52: // 'r', 'R' — [t]r
                    if lastKey != 0x74 && lastKey != 0x54 {
                        tempoff = count
                    }
                default:
                    if lastKey < 128 {
                        let lk = CChar(lastKey & 0x7F)
                        let consonantBytes = Array("BCDFGHJKLMNPQRSTVWXZbcdfghjklmnpqrstvwxz".utf8.map { CChar($0) })
                        if consonantBytes.contains(lk) {
                            tempoff = count
                        }
                    }
                }
            }
        }

        word[count] = UInt16(key)
        count += 1
    }

    func isValidModifier(_ c: UniChar, key: CChar) -> Bool {
        guard inputMethod != .off else { return false }

        let m = inputMethod == .vni ? ModifierMaps.vniModifierKeys : ModifierMaps.telexModifierKeys
        var normalizedKey = key
        if normalizedKey >= 65 && normalizedKey <= 90 {
            normalizedKey += 32
        }

        let keyChar = UnicodeScalar(UInt8(normalizedKey))
        guard let pIndex = m.firstIndex(of: Character(keyChar)) else {
            return false
        }

        let bitPosition = m.distance(from: m.startIndex, to: pIndex)
        let mmap = inputMethod == .vni ? ModifierMaps.vniModifiersMap : ModifierMaps.telexModifiersMap

        for (groupIndex, group) in vowelsMap.enumerated() {
            if group.contains(c) {
                let v = mmap[groupIndex]
                return (v >> bitPosition) & 1 == 1
            }
        }

        return false
    }

    private func checkShortcut() -> Int {
        // TODO: Implement shortcut lookup via AppState
        return -1
    }
}
