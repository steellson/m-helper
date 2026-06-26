import SwiftUI

@main
struct MHelperApp: App {
    var body: some Scene {
        MenuScene(
            viewModel: MenuSceneViewModel(
                services: [
                    Clicker()
                ]
            )
        )
    }
}
