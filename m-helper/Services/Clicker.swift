import CoreGraphics

final class Clicker: Service {
    let type: ServiceType = .clicker

    func act(in area: CGRect) {
        let point = area.randomPoint
        post(.leftMouseDown, at: point)
        post(.leftMouseUp, at: point)
    }

    private func post(
        _ type: CGEventType,
        at point: CGPoint
    ) {
        CGEvent(
            mouseEventSource: nil,
            mouseType: type,
            mouseCursorPosition: point,
            mouseButton: .left
        )?.post(tap: .cghidEventTap)
    }
}
