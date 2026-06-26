import SwiftUI

extension View {
    @ViewBuilder
    func shortcut(_ key: Character?) -> some View {
        if let key {
            self.keyboardShortcut(.init(key))
        } else {
            self
        }
    }
}
