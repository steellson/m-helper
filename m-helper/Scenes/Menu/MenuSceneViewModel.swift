import SwiftUI

@Observable
final class MenuSceneViewModel {
    var isStarted: Bool = false

    var items: [MenuItemModel] {
        [
            .init(
                kind: .app(title: "M-HELPER"),
                action: nil
            ),
            .init(
                kind: .togglable(title: isStarted ? "Stop" : "Start", key: "S"),
                action: nil
            ),
            .init(
                kind: .header(title: "SELECT MODE:"),
                action: nil
            ),
            .init(
                kind: .selectable(mode: Mode(
                    kind: .move,
                    isActive: selectedMode == .move
                )),
                action: nil
            ),
            .init(
                kind: .selectable(mode: Mode(
                    kind: .click,
                    isActive: selectedMode == .click
                )),
                action: nil
            ),
            .init(
                kind: .selectable(mode: Mode(
                    kind: .scroll,
                    isActive: selectedMode == .scroll
                )),
                action: nil
            ),
            .init(
                kind: .selectable(mode: Mode(
                    kind: .allCombined,
                    isActive: selectedMode == .allCombined
                )),
                action: nil
            ),
            .init(
                kind: .quit(title: "Quit", key: "Q"),
                action: nil
            )
        ]
    }

    private var selectedMode: Mode.Kind = .allCombined
    private let services: [any Service]

    init(
        services: [any Service]
    ) {
        self.services = services
    }
}
