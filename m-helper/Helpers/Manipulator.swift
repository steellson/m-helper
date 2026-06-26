import Foundation

final class Manipulator {
    var selectedMode: Mode.Kind {
        storage.value ?? .allCombined
    }

    private let storage: Storage<Mode.Kind>
    private let services: [any Service]

    init(
        storage: Storage<Mode.Kind>,
        services: [any Service]
    ) {
        self.storage = storage
        self.services = services
    }

    func change(mode: Mode.Kind) {
        storage.store(value: mode)
    }
}
