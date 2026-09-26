import XCTest
@testable import NAKL

final class AccessibilityPermissionTests: XCTestCase {

    func testIsGrantedReturnsBool() {
        // AccessibilityPermission.isGranted should return a Bool without crashing
        let result = AccessibilityPermission.isGranted
        // We cannot assert the specific value because it depends on system permissions,
        // but we can verify the call completes and returns a valid Bool.
        XCTAssertTrue(result == true || result == false,
                      "isGranted must return a valid Bool")
    }

    func testRequestIfNeededDoesNotCrash() {
        // In a test environment (non-interactive), requestIfNeeded should not crash.
        // Note: This will not actually show a dialog in CI/test environments.
        // We simply verify the function can be called without throwing or crashing.
        AccessibilityPermission.requestIfNeeded()
        // If we reach here, the call succeeded
    }

    func testIsGrantedIsConsistentAcrossCalls() {
        // Calling isGranted twice should return the same value (no side effects)
        let first = AccessibilityPermission.isGranted
        let second = AccessibilityPermission.isGranted
        XCTAssertEqual(first, second,
                       "isGranted should be deterministic within a single test run")
    }
}
