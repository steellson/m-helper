import CoreGraphics

final class Mover: Service {
    let type: ServiceType = .mover

    func act(in area: CGRect) {
        CGEvent(
            mouseEventSource: nil,
            mouseType: .mouseMoved,
            mouseCursorPosition: area.randomPoint,
            mouseButton: .left
        )?.post(tap: .cghidEventTap)
    }
}
