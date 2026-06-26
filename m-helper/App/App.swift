import SwiftUI

@main
struct MHelperApp: App {
    private var selectedMode: Mode.Kind {
        .allCombined
    }

    var body: some Scene {
        MenuScene(
            viewModel: MenuSceneViewModel(
                screenAreaSelector: ScreenAreaSelector(),
                manipulator: Manipulator(
                    selectedMode: selectedMode,
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
