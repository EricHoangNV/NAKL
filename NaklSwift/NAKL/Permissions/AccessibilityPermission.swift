import Cocoa
import ApplicationServices

enum AccessibilityPermission {

    static var isGranted: Bool {
        AXIsProcessTrustedWithOptions(nil)
    }

    @discardableResult
    static func requestIfNeeded() -> Bool {
        let options = ["AXTrustedCheckOptionPrompt": true] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }
}
