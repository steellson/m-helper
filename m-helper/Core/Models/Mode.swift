import Foundation

struct Mode {
    enum Kind {
        case click
        case move
        case scroll
        case allCombined
    }

    let kind: Kind
    let name: String
    var isActive: Bool

    init(
        kind: Kind,
        isActive: Bool
    ) {
        self.kind = kind
        self.isActive = isActive
        self.name = switch kind {
        case .click:       "Click"
        case .move:        "Move"
        case .scroll:      "Scroll"
        case .allCombined: "Combined"
        }
    }
}
