import SwiftUI

struct MenuItemView: View {
    private let action: (() -> Void)?
    private let config: MenuItemConfiguration

    var body: some View {
        VStack {
            if config.topSeparated { Divider() }

            if config.isButton {
                Button(config.title) { action?() }
                    .disabled(!config.isEnabled)
                    .shortcut(config.key)
            } else {
                Text(config.title)
                    .tint(.white)
                    .font(.headline)
            }

            if config.bottomSeparated { Divider() }
        }
    }

    init(
        config: MenuItemConfiguration,
        action: (() -> Void)? = nil
    ) {
        self.config = config
        self.action = action
    }
}
