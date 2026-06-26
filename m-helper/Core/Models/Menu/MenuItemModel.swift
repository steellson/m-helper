import Foundation

struct MenuItemModel: Identifiable {
    let id: String = UUID().uuidString

    let kind: MenuItemKind
    let action: (() -> Void)?

    init(
        kind: MenuItemKind,
        action: (() -> Void)?
    ) {
        self.kind = kind
        self.action = action
    }
}
