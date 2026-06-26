import SwiftUI

// MARK: - Main
struct MenuScene: Scene {
    private let viewModel: MenuSceneViewModel

    private var image: String {
        viewModel.isStarted
        ? "computermouse.fill"
        : "computermouse"
    }

    var body: some Scene {
        MenuBarExtra(
            "m-helper",
            systemImage: image
        ) {
            ForEach(viewModel.items, id: \.id) {
                MenuItemView(
                    config: $0.kind.config(),
                    action: $0.action
                )
            }
        }
        .menuBarExtraStyle(.menu)
    }

    init(viewModel: MenuSceneViewModel) {
        self.viewModel = viewModel
    }
}
