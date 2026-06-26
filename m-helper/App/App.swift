import SwiftUI

@main
struct MHelperApp: App {
    private let modeStorage: Storage<Mode.Kind> = Storage(key: "mode")
    private let intervalStorage: Storage<Interval> = Storage(key: "interval")

    var body: some Scene {
        MenuScene(
            viewModel: MenuSceneViewModel(
                screenAreaSelector: ScreenAreaSelector(),
                manipulator: Manipulator(
                    modeStorage: modeStorage,
                    intervalStorage: intervalStorage,
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
