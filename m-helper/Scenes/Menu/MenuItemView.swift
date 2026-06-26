import SwiftUI

struct MenuItemView: View {
    private let action: (() -> Void)?
    private let config: MenuItemConfiguration

    var body: some View {
        VStack {
            if config.topSeparated { Divider() }

            if config.isButton {
                Button { action?() } label: {
                    Text(config.title)
                        .font(.system(.subheadline, design: .monospaced).weight(.regular))
                }
                .disabled(!config.isEnabled)
                .shortcut(config.key)
            } else {
                Text(config.title)
                    .font(.system(.headline, design: .monospaced).weight(.bold))
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
