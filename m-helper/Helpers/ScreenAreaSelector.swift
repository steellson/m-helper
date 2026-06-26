import AppKit

@MainActor
final class ScreenAreaSelector {
    final class OverlayWindow: NSWindow {
        override var canBecomeKey: Bool { true }
    }

    private var window: NSWindow?

    func selectArea() async -> CGRect? {
        guard window == nil, let screen = NSScreen.main else {
            return nil
        }

        let view = SelectionView(frame: screen.frame)
        let window = OverlayWindow(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )

        window.level = .screenSaver
        window.backgroundColor = .clear
        window.isOpaque = false
        window.contentView = view
        self.window = window

        return await withCheckedContinuation { continuation in
            view.onFinish = { [weak self] rect in
                self?.window?.orderOut(nil)
                self?.window = nil

                continuation.resume(
                    returning: rect.map {
                        CGRect(
                            x: $0.minX,
                            y: screen.frame.height - $0.maxY,
                            width: $0.width,
                            height: $0.height
                        )
                    }
                )
            }

            NSApp.activate(ignoringOtherApps: true)
            window.makeKeyAndOrderFront(nil)
        }
    }
}

// MARK: - SelectionView
private final class SelectionView: NSView {
    var onFinish: ((NSRect?) -> Void)?

    private var origin: NSPoint = .zero
    private var rect: NSRect = .zero
    private let selectionLayer = CAShapeLayer()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true

        layer?.backgroundColor = NSColor.black.withAlphaComponent(0.15).cgColor
        selectionLayer.fillColor = NSColor.systemBlue.withAlphaComponent(0.25).cgColor
        selectionLayer.strokeColor = NSColor.systemBlue.cgColor
        selectionLayer.lineWidth = 1

        layer?.addSublayer(selectionLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var acceptsFirstResponder: Bool { true }

    override func viewWillMove(toWindow newWindow: NSWindow?) {
        super.viewWillMove(toWindow: newWindow)
        if newWindow == nil { finish(nil) }
    }

    // MARK: Mouse flow
    override func mouseDown(with event: NSEvent) {
        origin = convert(event.locationInWindow, from: nil)
    }

    override func mouseDragged(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        rect = NSRect(
            x: min(origin.x, point.x),
            y: min(origin.y, point.y),
            width: abs(point.x - origin.x),
            height: abs(point.y - origin.y)
        )

        // Обновляем только лёгкий слой, без перерисовки полноэкранного бэкстора.
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        selectionLayer.path = CGPath(rect: rect, transform: nil)
        CATransaction.commit()
    }

    override func mouseUp(with event: NSEvent) {
        let minimumSelected = rect.width > 2 && rect.height > 2
        finish(minimumSelected ? rect : nil)
    }

    override func keyDown(with event: NSEvent) {
        let isEscape = event.keyCode == 53
        if isEscape { finish(nil) }
    }

    private func finish(_ rect: NSRect?) {
        guard let onFinish else { return }
        self.onFinish = nil
        onFinish(rect)
    }
}
