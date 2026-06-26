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

        CGEvent(
            scrollWheelEvent2Source: nil,
            units: .line,
            wheelCount: 1,
            wheel1: .random(in: -10...10),
            wheel2: 0,
            wheel3: 0
        )?.post(tap: .cghidEventTap)
    }
}
