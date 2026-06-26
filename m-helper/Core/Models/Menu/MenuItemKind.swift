import Foundation

enum MenuItemKind {
    case app(title: String)
    case togglable(title: String, key: Character)
    case header(title: String)
    case value(title: String)
    case action(title: String)
    case selectable(mode: Mode)
    case quit(title: String, key: Character)

    func config() -> MenuItemConfiguration {
        switch self {
        case let .app(title):
                .init(
                    title: title,
                    key: nil,
                    isButton: false,
                    isEnabled: true,
                    topSeparated: false,
                    bottomSeparated: false
                )
        case let .togglable(title, key):
                .init(
                    title: title,
                    key: key,
                    isButton: true,
                    isEnabled: true,
                    topSeparated: false,
                    bottomSeparated: true
                )
        case let .header(title):
                .init(
                    title: title,
                    key: nil,
                    isButton: false,
                    isEnabled: true,
                    topSeparated: true,
                    bottomSeparated: false
                )
        case let .value(title):
                .init(
                    title: title,
                    key: nil,
                    isButton: false,
                    isEnabled: true,
                    topSeparated: false,
                    bottomSeparated: false
                )
        case let .action(title):
                .init(
                    title: title,
                    key: nil,
                    isButton: true,
                    isEnabled: true,
                    topSeparated: false,
                    bottomSeparated: false
                )
        case let .selectable(mode):
                .init(
                    title: mode.name,
                    key: nil,
                    isButton: true,
                    isEnabled: !mode.isActive,
                    topSeparated: false,
                    bottomSeparated: false
                )
        case let .quit(title, key):
                .init(
                    title: title,
                    key: key,
                    isButton: true,
                    isEnabled: true,
                    topSeparated: true,
                    bottomSeparated: false
                )
        }
    }
}
