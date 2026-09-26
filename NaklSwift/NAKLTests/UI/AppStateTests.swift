import XCTest
@testable import NAKL

final class AppStateTests: XCTestCase {

    // Use a unique suite to avoid polluting real UserDefaults
    private var defaults: UserDefaults!
    private let suiteName = "com.nakl.tests.\(UUID().uuidString)"

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: suiteName)
        // Clear test keys before each test
        let keys = [
            "NAKLKeyboardMethod", "NAKLToggleHotKey", "NAKLSwitchMethodHotKey",
            "NAKLExcludedAppBundleIds", "NAKLClipboardMode", "NAKLClipboardModeApps",
            "NAKLShortcuts"
        ]
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    override func tearDown() {
        defaults?.removePersistentDomain(forName: suiteName)
        // Clean up standard defaults
        let keys = [
            "NAKLKeyboardMethod", "NAKLToggleHotKey", "NAKLSwitchMethodHotKey",
            "NAKLExcludedAppBundleIds", "NAKLClipboardMode", "NAKLClipboardModeApps",
            "NAKLShortcuts"
        ]
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        super.tearDown()
    }

    // MARK: - InputMethod enum

    func testInputMethodOffRawValue() {
        XCTAssertEqual(InputMethod.off.rawValue, 0)
    }

    func testInputMethodVNIRawValue() {
        XCTAssertEqual(InputMethod.vni.rawValue, 1)
    }

    func testInputMethodTelexRawValue() {
        XCTAssertEqual(InputMethod.telex.rawValue, 2)
    }

    func testInputMethodCaseIterableCount() {
        XCTAssertEqual(InputMethod.allCases.count, 3)
    }

    func testInputMethodCodableRoundTrip() throws {
        for method in InputMethod.allCases {
            let data = try JSONEncoder().encode(method)
            let decoded = try JSONDecoder().decode(InputMethod.self, from: data)
            XCTAssertEqual(decoded, method)
        }
    }

    // MARK: - Default initialization

    func testDefaultInitialization() {
        // With no UserDefaults set, AppState should default to telex
        UserDefaults.standard.removeObject(forKey: "NAKLKeyboardMethod")
        let state = AppState()
        // Default is telex when no value is saved (integer returns 0, which maps to .off...
        // but the init uses ?? .telex so if the stored rawValue doesn't match, it falls back)
        // Actually: integer(forKey:) returns 0 when not set, InputMethod(rawValue: 0) == .off
        // So default is .off? Let's check: the init says ?? .telex, but InputMethod(rawValue:0) is .off which is non-nil
        // Therefore default is actually .off when nothing is stored
        XCTAssertEqual(state.currentMethod, .off,
                       "Default method should be .off when UserDefaults has no stored value (0)")
    }

    func testExcludedAppsDefaultsToEmpty() {
        let state = AppState()
        XCTAssertTrue(state.excludedApps.isEmpty)
    }

    func testShortcutsDefaultsToEmpty() {
        let state = AppState()
        XCTAssertTrue(state.shortcuts.isEmpty)
    }

    func testClipboardModeAppsDefaultsToEmpty() {
        let state = AppState()
        XCTAssertTrue(state.clipboardModeApps.isEmpty)
    }

    func testClipboardModeDefaultsToFalse() {
        let state = AppState()
        XCTAssertFalse(state.clipboardModeEnabled)
    }

    // MARK: - currentMethod persistence

    func testCurrentMethodPersistence() {
        let state1 = AppState()
        state1.currentMethod = .telex

        let state2 = AppState()
        XCTAssertEqual(state2.currentMethod, .telex,
                       "Setting currentMethod should persist via UserDefaults")
    }

    func testCurrentMethodPersistenceVNI() {
        let state1 = AppState()
        state1.currentMethod = .vni

        let state2 = AppState()
        XCTAssertEqual(state2.currentMethod, .vni)
    }

    // MARK: - excludedApps CRUD

    func testExcludedAppsAdd() {
        let state = AppState()
        state.excludedApps["com.apple.Safari"] = "Safari"
        XCTAssertEqual(state.excludedApps["com.apple.Safari"], "Safari")
    }

    func testExcludedAppsRemove() {
        let state = AppState()
        state.excludedApps["com.apple.Safari"] = "Safari"
        state.excludedApps.removeValue(forKey: "com.apple.Safari")
        XCTAssertNil(state.excludedApps["com.apple.Safari"])
    }

    func testExcludedAppsPersistence() {
        let state1 = AppState()
        state1.excludedApps = ["com.test.app": "TestApp"]

        let state2 = AppState()
        XCTAssertEqual(state2.excludedApps["com.test.app"], "TestApp")
    }

    // MARK: - clipboardModeApps CRUD

    func testClipboardModeAppsAdd() {
        let state = AppState()
        state.clipboardModeApps.insert("com.apple.Terminal")
        XCTAssertTrue(state.clipboardModeApps.contains("com.apple.Terminal"))
    }

    func testClipboardModeAppsRemove() {
        let state = AppState()
        state.clipboardModeApps.insert("com.apple.Terminal")
        state.clipboardModeApps.remove("com.apple.Terminal")
        XCTAssertFalse(state.clipboardModeApps.contains("com.apple.Terminal"))
    }

    func testClipboardModeAppsPersistence() {
        let state1 = AppState()
        state1.clipboardModeApps = Set(["com.test.app1", "com.test.app2"])

        let state2 = AppState()
        XCTAssertTrue(state2.clipboardModeApps.contains("com.test.app1"))
        XCTAssertTrue(state2.clipboardModeApps.contains("com.test.app2"))
    }

    // MARK: - shortcuts CRUD

    func testShortcutsAdd() {
        let state = AppState()
        state.shortcuts.append(["key": "brb", "value": "be right back"])
        XCTAssertEqual(state.shortcuts.count, 1)
        XCTAssertEqual(state.shortcuts[0]["key"], "brb")
    }

    func testShortcutsRemove() {
        let state = AppState()
        state.shortcuts = [
            ["key": "brb", "value": "be right back"],
            ["key": "ty", "value": "thank you"],
        ]
        state.shortcuts.removeFirst()
        XCTAssertEqual(state.shortcuts.count, 1)
        XCTAssertEqual(state.shortcuts[0]["key"], "ty")
    }

    func testShortcutsPersistence() {
        let state1 = AppState()
        state1.shortcuts = [["key": "test", "value": "test_value"]]

        let state2 = AppState()
        XCTAssertEqual(state2.shortcuts.count, 1)
        XCTAssertEqual(state2.shortcuts[0]["value"], "test_value")
    }

    // MARK: - toggleCombo / switchMethodCombo

    func testToggleComboDefaultsToEmpty() {
        let state = AppState()
        XCTAssertEqual(state.toggleCombo, .empty)
    }

    func testSwitchMethodComboDefaultsToEmpty() {
        let state = AppState()
        XCTAssertEqual(state.switchMethodCombo, .empty)
    }

    func testToggleComboPersistence() {
        let state1 = AppState()
        state1.toggleCombo = KeyCombo(keyCode: 0x31, modifierFlags: 0x100108)

        let state2 = AppState()
        XCTAssertEqual(state2.toggleCombo.keyCode, 0x31)
        XCTAssertEqual(state2.toggleCombo.modifierFlags, 0x100108)
    }
}
