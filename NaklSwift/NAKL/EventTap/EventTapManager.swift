import Cocoa
import CoreGraphics

final class EventTapManager: @unchecked Sendable {

    let engine: VietnameseEngine
    let appState: AppState

    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var tapThread: Thread?

    static let controlKeys: UInt64 =
        CGEventFlags.maskCommand.rawValue |
        CGEventFlags.maskAlternate.rawValue |
        CGEventFlags.maskControl.rawValue |
        CGEventFlags.maskSecondaryFn.rawValue |
        CGEventFlags.maskHelp.rawValue

    init(engine: VietnameseEngine, appState: AppState) {
        self.engine = engine
        self.appState = appState
    }

    func start() {
        let mask: CGEventMask =
            (1 << CGEventType.keyDown.rawValue) |
            (1 << CGEventType.keyUp.rawValue) |
            (1 << CGEventType.leftMouseDown.rawValue) |
            (1 << CGEventType.rightMouseDown.rawValue) |
            (1 << CGEventType.otherMouseDown.rawValue)

        let refcon = Unmanaged.passUnretained(self).toOpaque()

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: mask,
            callback: eventTapCallback,
            userInfo: refcon
        ) else {
            print("[NAKL] ERROR: Failed to create event tap. Check accessibility permissions.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                print("[NAKL] Retrying event tap creation...")
                self?.start()
            }
            return
        }
        print("[NAKL] Event tap created successfully")

        self.eventTap = tap
        self.runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)

        tapThread = Thread { [weak self] in
            guard let self, let source = self.runLoopSource else { return }
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
            CGEvent.tapEnable(tap: tap, enable: true)
            print("[NAKL] Event tap enabled, run loop starting")
            CFRunLoopRun()
        }
        tapThread?.qualityOfService = .userInteractive
        tapThread?.name = "com.zepvn.NAKL2.eventTap"
        tapThread?.start()
    }

    func handleEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        let flags = event.flags.rawValue

        if flags & SyntheticEventEmitter.magicFlag.rawValue != 0 {
            return Unmanaged.passUnretained(event)
        }

        switch type {
        case .tapDisabledByTimeout:
            if let tap = eventTap {
                CGEvent.tapEnable(tap: tap, enable: true)
            }
            return Unmanaged.passUnretained(event)

        case .leftMouseDown, .rightMouseDown, .otherMouseDown:
            engine.clearBufferThreadSafe()
            return Unmanaged.passUnretained(event)

        case .keyUp:
            return Unmanaged.passUnretained(event)

        case .keyDown:
            return handleKeyDown(proxy: proxy, event: event)

        default:
            return Unmanaged.passUnretained(event)
        }
    }

    private func handleKeyDown(proxy: CGEventTapProxy, event: CGEvent) -> Unmanaged<CGEvent>? {
        let flags = event.flags.rawValue
        let keycode = UInt16(event.getIntegerValueField(.keyboardEventKeycode))

        var chars: [UniChar] = [0]
        var actualLength: Int = 0
        event.keyboardGetUnicodeString(maxStringLength: 1, actualStringLength: &actualLength, unicodeString: &chars)
        let key = chars[0]

        if let bundleId = NSWorkspace.shared.frontmostApplication?.bundleIdentifier {
            if appState.excludedApps[bundleId] != nil {
                return Unmanaged.passUnretained(event)
            }
        }

        if flags & Self.controlKeys != 0 {
            var validShortcut = false

            if appState.toggleCombo.matches(flags: flags & Self.controlKeys, keycode: keycode) {
                if engine.inputMethod == .off {
                    engine.inputMethod = appState.currentMethod
                } else {
                    engine.inputMethod = .off
                }
                DispatchQueue.main.async { [weak self] in
                    self?.appState.activeMethod = self?.engine.inputMethod ?? .off
                }
                validShortcut = true
            }

            if appState.switchMethodCombo.matches(flags: flags & Self.controlKeys, keycode: keycode) {
                switch engine.inputMethod {
                case .vni: engine.inputMethod = .telex
                case .telex: engine.inputMethod = .vni
                case .off: break
                }
                if engine.inputMethod != .off {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.appState.currentMethod = self.engine.inputMethod
                        self.appState.activeMethod = self.engine.inputMethod
                    }
                }
                validShortcut = true
            }

            engine.clearBufferThreadSafe()
            if validShortcut { return nil }
            return Unmanaged.passUnretained(event)
        }

        if KeyCode.navigationKeys.contains(keycode) {
            engine.clearBufferThreadSafe()
            return Unmanaged.passUnretained(event)
        }

        if engine.inputMethod == .off {
            return Unmanaged.passUnretained(event)
        }

        let separators = ModifierMaps.separators[engine.inputMethod.rawValue]
        if key < 128, separators.utf8.contains(UInt8(key)) {
            engine.clearBufferThreadSafe()
            return Unmanaged.passUnretained(event)
        }

        let result = engine.addKeyThreadSafe(key)

        if result == -1 {
            return Unmanaged.passUnretained(event)
        }

        let output = engine.getOutputSlice()

        if appState.clipboardModeEnabled || appState.clipboardModeApps.contains(
            NSWorkspace.shared.frontmostApplication?.bundleIdentifier ?? ""
        ) {
            let text = String(output.pointer.dropFirst(output.backspaceCount).prefix(output.outputLength).compactMap { UnicodeScalar($0).map { Character($0) } })
            ClipboardInserter.insert(text: text, proxy: proxy, backspaceCount: output.backspaceCount)
        } else {
            SyntheticEventEmitter.emit(
                proxy: proxy,
                buffer: output.pointer,
                backspaceCount: output.backspaceCount,
                outputLength: output.outputLength
            )
        }

        return nil
    }
}

private func eventTapCallback(
    proxy: CGEventTapProxy,
    type: CGEventType,
    event: CGEvent,
    userInfo: UnsafeMutableRawPointer?
) -> Unmanaged<CGEvent>? {
    guard let userInfo else { return Unmanaged.passUnretained(event) }
    let manager = Unmanaged<EventTapManager>.fromOpaque(userInfo).takeUnretainedValue()
    return manager.handleEvent(proxy: proxy, type: type, event: event)
}
