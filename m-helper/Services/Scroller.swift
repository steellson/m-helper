import CoreGraphics

final class Scroller: Service {
    let type: ServiceType = .scroller

    func act(in area: CGRect) {
        CGEvent(
            mouseEventSource: nil,
            mouseType: .mouseMoved,
            mouseCursorPosition: area.randomPoint,
            mouseButton: .left
        )?.post(tap: .cghidEventTap)

        let magnitude = Int32.random(in: 2...100)
        let amount = Bool.random() ? magnitude : -magnitude

        CGEvent(
            scrollWheelEvent2Source: nil,
            units: .line,
            wheelCount: 1,
            wheel1: amount,
            wheel2: 0,
            wheel3: 0
        )?.post(tap: .cghidEventTap)
    }
}
