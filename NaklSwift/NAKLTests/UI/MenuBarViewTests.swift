import XCTest
@testable import NAKL

final class MenuBarViewTests: XCTestCase {

    private let defaultsKeys = [
        "NAKLKeyboardMethod", "NAKLToggleHotKey", "NAKLSwitchMethodHotKey",
        "NAKLExcludedAppBundleIds", "NAKLClipboardMode", "NAKLClipboardModeApps",
        "NAKLShortcuts"
    ]

    override func setUp() {
        super.setUp()
        for key in defaultsKeys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    override func tearDown() {
        for key in defaultsKeys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        super.tearDown()
    }

    // MARK: - InputMethod enum cases

    func testInputMethodHasOffCase() {
        let method = InputMethod.off
        XCTAssertEqual(method.rawValue, 0)
    }

    func testInputMethodHasVNICase() {
        let method = InputMethod.vni
        XCTAssertEqual(method.rawValue, 1)
    }

    func testInputMethodHasTelexCase() {
        let method = InputMethod.telex
        XCTAssertEqual(method.rawValue, 2)
    }

    func testInputMethodCaseIterableContainsAllThree() {
        let allCases = InputMethod.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.off))
        XCTAssertTrue(allCases.contains(.vni))
        XCTAssertTrue(allCases.contains(.telex))
    }

    func testInputMethodCaseIterableOrder() {
        let allCases = InputMethod.allCases
        XCTAssertEqual(allCases[0], .off)
        XCTAssertEqual(allCases[1], .vni)
        XCTAssertEqual(allCases[2], .telex)
    }

    func testInputMethodRawValueRoundTrip() {
        for method in InputMethod.allCases {
            let reconstructed = InputMethod(rawValue: method.rawValue)
            XCTAssertEqual(reconstructed, method)
        }
    }

    func testInputMethodInvalidRawValueReturnsNil() {
        XCTAssertNil(InputMethod(rawValue: 3))
        XCTAssertNil(InputMethod(rawValue: -1))
        XCTAssertNil(InputMethod(rawValue: 99))
    }

    // MARK: - activeMethod changes

    func testActiveMethodSetToOff() {
        let state = AppState()
        state.activeMethod = .off
        XCTAssertEqual(state.activeMethod, .off)
    }

    func testActiveMethodSetToVNI() {
        let state = AppState()
        state.activeMethod = .vni
        XCTAssertEqual(state.activeMethod, .vni)
    }

    func testActiveMethodSetToTelex() {
        let state = AppState()
        state.activeMethod = .telex
        XCTAssertEqual(state.activeMethod, .telex)
    }

    func testActiveMethodCyclesThroughAll() {
        let state = AppState()
        for method in InputMethod.allCases {
            state.activeMethod = method
            XCTAssertEqual(state.activeMethod, method)
        }
    }

    // MARK: - Setting activeMethod to .off does not change currentMethod

    func testSettingActiveMethodToOffDoesNotChangeCurrentMethod() {
        let state = AppState()
        state.currentMethod = .telex
        state.activeMethod = .off
        XCTAssertEqual(state.currentMethod, .telex,
                       "Setting activeMethod to .off should not alter currentMethod")
    }

    func testSettingActiveMethodToOffPreservesVNICurrentMethod() {
        let state = AppState()
        state.currentMethod = .vni
        state.activeMethod = .off
        XCTAssertEqual(state.currentMethod, .vni,
                       "Setting activeMethod to .off should preserve VNI currentMethod")
    }

    // MARK: - Engine inputMethod sync with appState

    func testEngineInputMethodSyncWithActiveMethodTelex() {
        let state = AppState()
        let engine = VietnameseEngine()
        state.activeMethod = .telex
        engine.inputMethod = state.activeMethod
        XCTAssertEqual(engine.inputMethod, .telex)
    }

    func testEngineInputMethodSyncWithActiveMethodVNI() {
        let state = AppState()
        let engine = VietnameseEngine()
        state.activeMethod = .vni
        engine.inputMethod = state.activeMethod
        XCTAssertEqual(engine.inputMethod, .vni)
    }

    func testEngineInputMethodSyncWithActiveMethodOff() {
        let state = AppState()
        let engine = VietnameseEngine()
        state.activeMethod = .off
        engine.inputMethod = state.activeMethod
        XCTAssertEqual(engine.inputMethod, .off)
    }

    func testEngineDefaultInputMethodIsTelex() {
        let engine = VietnameseEngine()
        XCTAssertEqual(engine.inputMethod, .telex)
    }

    func testEngineInputMethodCanBeSetDirectly() {
        let engine = VietnameseEngine()
        engine.inputMethod = .vni
        XCTAssertEqual(engine.inputMethod, .vni)
        engine.inputMethod = .off
        XCTAssertEqual(engine.inputMethod, .off)
    }

    // MARK: - MenuBar behavior: selecting a method updates both activeMethod and engine

    func testSelectingMethodUpdatesActiveAndEngine() {
        let state = AppState()
        let engine = VietnameseEngine()

        // Simulate what MenuBarView button does for each method
        for method in InputMethod.allCases {
            state.activeMethod = method
            engine.inputMethod = method
            if method != .off {
                state.currentMethod = method
            }

            XCTAssertEqual(state.activeMethod, method)
            XCTAssertEqual(engine.inputMethod, method)
        }
    }

    func testSelectingOffDoesNotUpdateCurrentMethod() {
        let state = AppState()
        let engine = VietnameseEngine()

        // Set to VNI first
        state.activeMethod = .vni
        engine.inputMethod = .vni
        state.currentMethod = .vni

        // Select off
        state.activeMethod = .off
        engine.inputMethod = .off
        // Intentionally do NOT set currentMethod (matching MenuBarView logic)

        XCTAssertEqual(state.activeMethod, .off)
        XCTAssertEqual(engine.inputMethod, .off)
        XCTAssertEqual(state.currentMethod, .vni,
                       "currentMethod should remain .vni after selecting .off")
    }

    func testSelectingTelexUpdatesBothActiveAndCurrent() {
        let state = AppState()
        let engine = VietnameseEngine()

        state.activeMethod = .telex
        engine.inputMethod = .telex
        state.currentMethod = .telex

        XCTAssertEqual(state.activeMethod, .telex)
        XCTAssertEqual(state.currentMethod, .telex)
        XCTAssertEqual(engine.inputMethod, .telex)
    }

    func testSelectingVNIUpdatesBothActiveAndCurrent() {
        let state = AppState()
        let engine = VietnameseEngine()

        state.activeMethod = .vni
        engine.inputMethod = .vni
        state.currentMethod = .vni

        XCTAssertEqual(state.activeMethod, .vni)
        XCTAssertEqual(state.currentMethod, .vni)
        XCTAssertEqual(engine.inputMethod, .vni)
    }

    // MARK: - InputMethod Codable conformance

    func testInputMethodEncodeDecode() throws {
        for method in InputMethod.allCases {
            let data = try JSONEncoder().encode(method)
            let decoded = try JSONDecoder().decode(InputMethod.self, from: data)
            XCTAssertEqual(decoded, method)
        }
    }

    func testInputMethodDecodeFromRawIntegerJSON() throws {
        let json0 = Data("0".utf8)
        let json1 = Data("1".utf8)
        let json2 = Data("2".utf8)

        XCTAssertEqual(try JSONDecoder().decode(InputMethod.self, from: json0), .off)
        XCTAssertEqual(try JSONDecoder().decode(InputMethod.self, from: json1), .vni)
        XCTAssertEqual(try JSONDecoder().decode(InputMethod.self, from: json2), .telex)
    }

    // MARK: - InputMethod Equatable

    func testInputMethodEquality() {
        XCTAssertEqual(InputMethod.off, InputMethod.off)
        XCTAssertEqual(InputMethod.vni, InputMethod.vni)
        XCTAssertEqual(InputMethod.telex, InputMethod.telex)
        XCTAssertNotEqual(InputMethod.off, InputMethod.vni)
        XCTAssertNotEqual(InputMethod.vni, InputMethod.telex)
        XCTAssertNotEqual(InputMethod.off, InputMethod.telex)
    }
}
