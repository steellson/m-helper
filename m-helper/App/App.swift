import SwiftUI

@main
struct MHelperApp: App {
    private let storage: Storage<Mode.Kind> = Storage(key: "mode")

    var body: some Scene {
        MenuScene(
            viewModel: MenuSceneViewModel(
                screenAreaSelector: ScreenAreaSelector(),
                manipulator: Manipulator(
                    storage: storage,
                    services: [
                        Mover(),
                        Clicker(),
                        Scroller()
                    ]
                )
            )
        )
    }
}
