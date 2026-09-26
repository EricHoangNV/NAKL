import XCTest
@testable import NAKL

final class PreferencesViewTests: XCTestCase {

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

    // MARK: - General settings: method picker binding roundtrip

    func testMethodPickerBindingRoundTripVNI() {
        let state = AppState()
        state.currentMethod = .vni
        XCTAssertEqual(state.currentMethod, .vni)

        // Verify persistence
        let state2 = AppState()
        XCTAssertEqual(state2.currentMethod, .vni)
    }

    func testMethodPickerBindingRoundTripTelex() {
        let state = AppState()
        state.currentMethod = .telex
        XCTAssertEqual(state.currentMethod, .telex)

        let state2 = AppState()
        XCTAssertEqual(state2.currentMethod, .telex)
    }

    func testMethodPickerSwitchBetweenMethods() {
        let state = AppState()
        state.currentMethod = .vni
        XCTAssertEqual(state.currentMethod, .vni)

        state.currentMethod = .telex
        XCTAssertEqual(state.currentMethod, .telex)

        state.currentMethod = .vni
        XCTAssertEqual(state.currentMethod, .vni)
    }

    // MARK: - General settings: clipboard mode toggle

    func testClipboardModeToggleOn() {
        let state = AppState()
        state.clipboardModeEnabled = true
        XCTAssertTrue(state.clipboardModeEnabled)
    }

    func testClipboardModeToggleOff() {
        let state = AppState()
        state.clipboardModeEnabled = true
        state.clipboardModeEnabled = false
        XCTAssertFalse(state.clipboardModeEnabled)
    }

    func testClipboardModeTogglePersistence() {
        let state1 = AppState()
        state1.clipboardModeEnabled = true

        let state2 = AppState()
        XCTAssertTrue(state2.clipboardModeEnabled)
    }

    // MARK: - Hotkeys tab: KeyCombo creation

    func testKeyComboCreation() {
        let combo = KeyCombo(keyCode: 0x31, modifierFlags: 0x100108)
        XCTAssertEqual(combo.keyCode, 0x31)
        XCTAssertEqual(combo.modifierFlags, 0x100108)
    }

    func testKeyComboEmpty() {
        let combo = KeyCombo.empty
        XCTAssertEqual(combo.keyCode, 0)
        XCTAssertEqual(combo.modifierFlags, 0)
    }

    func testKeyComboEquality() {
        let a = KeyCombo(keyCode: 10, modifierFlags: 256)
        let b = KeyCombo(keyCode: 10, modifierFlags: 256)
        let c = KeyCombo(keyCode: 11, modifierFlags: 256)
        XCTAssertEqual(a, b)
        XCTAssertNotEqual(a, c)
    }

    func testKeyComboMatchesCorrectFlagsAndKeycode() {
        let combo = KeyCombo(keyCode: 0x0C, modifierFlags: 0x100108)
        XCTAssertTrue(combo.matches(flags: 0x100108, keycode: 0x0C))
    }

    func testKeyComboDoesNotMatchWrongFlags() {
        let combo = KeyCombo(keyCode: 0x0C, modifierFlags: 0x100108)
        XCTAssertFalse(combo.matches(flags: 0x000108, keycode: 0x0C))
    }

    func testKeyComboDoesNotMatchWrongKeycode() {
        let combo = KeyCombo(keyCode: 0x0C, modifierFlags: 0x100108)
        XCTAssertFalse(combo.matches(flags: 0x100108, keycode: 0x0D))
    }

    func testKeyComboEmptyNeverMatches() {
        let combo = KeyCombo.empty
        XCTAssertFalse(combo.matches(flags: 0, keycode: 0))
        XCTAssertFalse(combo.matches(flags: 0x100108, keycode: 0x31))
    }

    // MARK: - Hotkeys tab: KeyCombo display string logic

    func testKeyComboControlModifierFlag() {
        // CGEventFlags.maskControl = 0x40000 (262144)
        let controlFlag: UInt64 = 0x40000
        let combo = KeyCombo(keyCode: 0x00, modifierFlags: controlFlag)
        // Verify the flag is the control mask
        XCTAssertNotEqual(combo.modifierFlags & 0x40000, 0,
                          "Control modifier flag should be set")
    }

    func testKeyComboAlternateModifierFlag() {
        // CGEventFlags.maskAlternate = 0x80000 (524288)
        let altFlag: UInt64 = 0x80000
        let combo = KeyCombo(keyCode: 0x00, modifierFlags: altFlag)
        XCTAssertNotEqual(combo.modifierFlags & 0x80000, 0,
                          "Alternate modifier flag should be set")
    }

    func testKeyComboShiftModifierFlag() {
        // CGEventFlags.maskShift = 0x20000 (131072)
        let shiftFlag: UInt64 = 0x20000
        let combo = KeyCombo(keyCode: 0x00, modifierFlags: shiftFlag)
        XCTAssertNotEqual(combo.modifierFlags & 0x20000, 0,
                          "Shift modifier flag should be set")
    }

    func testKeyComboCommandModifierFlag() {
        // CGEventFlags.maskCommand = 0x100000 (1048576)
        let cmdFlag: UInt64 = 0x100000
        let combo = KeyCombo(keyCode: 0x00, modifierFlags: cmdFlag)
        XCTAssertNotEqual(combo.modifierFlags & 0x100000, 0,
                          "Command modifier flag should be set")
    }

    func testKeyComboCombinedModifierFlags() {
        // Control + Command
        let flags: UInt64 = 0x40000 | 0x100000
        let combo = KeyCombo(keyCode: 0x31, modifierFlags: flags)
        XCTAssertNotEqual(combo.modifierFlags & 0x40000, 0)
        XCTAssertNotEqual(combo.modifierFlags & 0x100000, 0)
        XCTAssertEqual(combo.modifierFlags & 0x80000, 0, "Alt should not be set")
        XCTAssertEqual(combo.modifierFlags & 0x20000, 0, "Shift should not be set")
    }

    func testKeyComboAllModifiersCombined() {
        let flags: UInt64 = 0x40000 | 0x80000 | 0x20000 | 0x100000
        let combo = KeyCombo(keyCode: 0x00, modifierFlags: flags)
        XCTAssertNotEqual(combo.modifierFlags & 0x40000, 0)
        XCTAssertNotEqual(combo.modifierFlags & 0x80000, 0)
        XCTAssertNotEqual(combo.modifierFlags & 0x20000, 0)
        XCTAssertNotEqual(combo.modifierFlags & 0x100000, 0)
    }

    // MARK: - Hotkeys tab: toggle and switch combos persistence

    func testToggleComboPersistence() {
        let state1 = AppState()
        let combo = KeyCombo(keyCode: 0x31, modifierFlags: 0x100108)
        state1.toggleCombo = combo

        let state2 = AppState()
        XCTAssertEqual(state2.toggleCombo.keyCode, combo.keyCode)
        XCTAssertEqual(state2.toggleCombo.modifierFlags, combo.modifierFlags)
    }

    func testSwitchMethodComboPersistence() {
        let state1 = AppState()
        let combo = KeyCombo(keyCode: 0x0C, modifierFlags: 0x80000)
        state1.switchMethodCombo = combo

        let state2 = AppState()
        XCTAssertEqual(state2.switchMethodCombo.keyCode, combo.keyCode)
        XCTAssertEqual(state2.switchMethodCombo.modifierFlags, combo.modifierFlags)
    }

    func testClearToggleCombo() {
        let state = AppState()
        state.toggleCombo = KeyCombo(keyCode: 0x31, modifierFlags: 0x100108)
        state.toggleCombo = .empty
        XCTAssertEqual(state.toggleCombo, .empty)
    }

    // MARK: - Shortcuts tab: add/edit/remove entries

    func testAddShortcutEntry() {
        let state = AppState()
        state.shortcuts.append(["shortcut": "brb", "text": "be right back"])
        XCTAssertEqual(state.shortcuts.count, 1)
        XCTAssertEqual(state.shortcuts[0]["shortcut"], "brb")
        XCTAssertEqual(state.shortcuts[0]["text"], "be right back")
    }

    func testEditShortcutEntry() {
        let state = AppState()
        state.shortcuts.append(["shortcut": "brb", "text": "be right back"])
        state.shortcuts[0]["text"] = "I will be right back"
        XCTAssertEqual(state.shortcuts[0]["text"], "I will be right back")
    }

    func testRemoveLastShortcutEntry() {
        let state = AppState()
        state.shortcuts = [
            ["shortcut": "brb", "text": "be right back"],
            ["shortcut": "ty", "text": "thank you"],
        ]
        state.shortcuts.removeLast()
        XCTAssertEqual(state.shortcuts.count, 1)
        XCTAssertEqual(state.shortcuts[0]["shortcut"], "brb")
    }

    func testRemoveShortcutFromEmpty() {
        let state = AppState()
        XCTAssertTrue(state.shortcuts.isEmpty)
        // The view disables the button when empty, so removeLast is not called
        // Just verify the state is safe
        XCTAssertEqual(state.shortcuts.count, 0)
    }

    func testShortcutsPersistence() {
        let state1 = AppState()
        state1.shortcuts = [
            ["shortcut": "addr", "text": "123 Main St"],
            ["shortcut": "sig", "text": "Best regards"],
        ]

        let state2 = AppState()
        XCTAssertEqual(state2.shortcuts.count, 2)
        XCTAssertEqual(state2.shortcuts[0]["shortcut"], "addr")
        XCTAssertEqual(state2.shortcuts[1]["text"], "Best regards")
    }

    func testAddMultipleShortcuts() {
        let state = AppState()
        for i in 0..<5 {
            state.shortcuts.append(["shortcut": "s\(i)", "text": "expansion \(i)"])
        }
        XCTAssertEqual(state.shortcuts.count, 5)
        XCTAssertEqual(state.shortcuts[4]["shortcut"], "s4")
    }

    // MARK: - Excluded Apps tab: add/remove excluded app

    func testAddExcludedApp() {
        let state = AppState()
        state.excludedApps["com.apple.Safari"] = "Safari"
        XCTAssertEqual(state.excludedApps["com.apple.Safari"], "Safari")
    }

    func testRemoveExcludedApp() {
        let state = AppState()
        state.excludedApps["com.apple.Safari"] = "Safari"
        state.excludedApps.removeValue(forKey: "com.apple.Safari")
        XCTAssertNil(state.excludedApps["com.apple.Safari"])
        XCTAssertTrue(state.excludedApps.isEmpty)
    }

    func testExcludedAppsPersistence() {
        let state1 = AppState()
        state1.excludedApps = [
            "com.apple.Safari": "Safari",
            "com.google.Chrome": "Google Chrome",
        ]

        let state2 = AppState()
        XCTAssertEqual(state2.excludedApps.count, 2)
        XCTAssertEqual(state2.excludedApps["com.apple.Safari"], "Safari")
        XCTAssertEqual(state2.excludedApps["com.google.Chrome"], "Google Chrome")
    }

    // MARK: - Excluded Apps tab: clipboard mode per-app

    func testClipboardModePerAppAdd() {
        let state = AppState()
        state.excludedApps["com.microsoft.VSCode"] = "VS Code"
        state.clipboardModeApps.insert("com.microsoft.VSCode")
        XCTAssertTrue(state.clipboardModeApps.contains("com.microsoft.VSCode"))
    }

    func testClipboardModePerAppRemoveAlsoRemovesFromClipboardApps() {
        let state = AppState()
        state.excludedApps["com.microsoft.VSCode"] = "VS Code"
        state.clipboardModeApps.insert("com.microsoft.VSCode")

        // Simulate the onDelete behavior from ExcludedAppsSettingsView
        state.excludedApps.removeValue(forKey: "com.microsoft.VSCode")
        state.clipboardModeApps.remove("com.microsoft.VSCode")

        XCTAssertNil(state.excludedApps["com.microsoft.VSCode"])
        XCTAssertFalse(state.clipboardModeApps.contains("com.microsoft.VSCode"))
    }

    func testClipboardModeAppsPersistence() {
        let state1 = AppState()
        state1.clipboardModeApps = Set(["com.app1", "com.app2"])

        let state2 = AppState()
        XCTAssertTrue(state2.clipboardModeApps.contains("com.app1"))
        XCTAssertTrue(state2.clipboardModeApps.contains("com.app2"))
        XCTAssertEqual(state2.clipboardModeApps.count, 2)
    }

    // MARK: - PreferencesView has 4 tabs (verified through structure)

    @MainActor
    func testPreferencesViewHasFourTabLabels() {
        // We cannot instantiate the SwiftUI view in unit tests, but we can verify
        // that the four sub-view types exist and accept AppState
        let state = AppState()

        // Verify all four tab view types can be constructed with AppState
        let _ = GeneralSettingsView(appState: state)
        let _ = HotKeySettingsView(appState: state)
        let _ = ExcludedAppsSettingsView(appState: state)
        let _ = ShortcutsSettingsView(appState: state)

        // If we get here without error, all four views are valid
    }

    @MainActor
    func testPreferencesViewCanBeCreated() {
        let state = AppState()
        let _ = PreferencesView(appState: state)
        // Verify it compiles and can be instantiated
    }

    // MARK: - KeyCombo Codable roundtrip

    func testKeyComboCodableRoundTrip() throws {
        let original = KeyCombo(keyCode: 0x31, modifierFlags: 0x100108)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(KeyCombo.self, from: data)
        XCTAssertEqual(decoded, original)
    }

    func testKeyComboEmptyCodableRoundTrip() throws {
        let original = KeyCombo.empty
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(KeyCombo.self, from: data)
        XCTAssertEqual(decoded, original)
    }
}
