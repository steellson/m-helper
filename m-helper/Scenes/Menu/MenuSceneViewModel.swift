import SwiftUI

@Observable
final class MenuSceneViewModel {
    var isStarted: Bool = false

    var items: [MenuItemModel] {
        [
            .init(
                kind: .app(title: "M-HELPER 👾"),
                action: nil
            ),
            .init(
                kind: .togglable(title: isStarted ? "Stop" : "Start", key: "S"),
                action: { [weak self] in
                    self?.didTapStartOrStop()
                }
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
                action: { [weak self] in
                    self?.didChangeMode(.move)
                }
            ),
            .init(
                kind: .selectable(mode: Mode(
                    kind: .click,
                    isActive: selectedMode == .click
                )),
                action: { [weak self] in
                    self?.didChangeMode(.click)
                }
            ),
            .init(
                kind: .selectable(mode: Mode(
                    kind: .scroll,
                    isActive: selectedMode == .scroll
                )),
                action: { [weak self] in
                    self?.didChangeMode(.scroll)
                }
            ),
            .init(
                kind: .selectable(mode: Mode(
                    kind: .allCombined,
                    isActive: selectedMode == .allCombined
                )),
                action: { [weak self] in
                    self?.didChangeMode(.allCombined)
                }
            ),
            .init(
                kind: .quit(title: "Quit", key: "Q"),
                action: { [weak self] in
                    self?.didTapOnQuit()
                }
            )
        ]
    }

    private var selectedMode: Mode.Kind {
        manipulator.selectedMode
    }

    private let screenAreaSelector: ScreenAreaSelector
    private let manipulator: Manipulator

    init(
        screenAreaSelector: ScreenAreaSelector,
        manipulator: Manipulator
    ) {
        self.screenAreaSelector = screenAreaSelector
        self.manipulator = manipulator
    }
}

// MARK: - Metohds
private extension MenuSceneViewModel {
    func didTapStartOrStop() {
        guard !isStarted else {
            isStarted.toggle()
            return
        }

        Task {
            let area = await screenAreaSelector.selectArea()
            guard let area else { return }

            // Call services
            isStarted.toggle()
        }
    }

    func didChangeMode(_ mode: Mode.Kind) {
        manipulator.selectedMode = mode
    }

    func didTapOnQuit() {
        NSApp.terminate(self)
    }
}
