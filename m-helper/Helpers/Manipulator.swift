import Foundation

final class Manipulator {
    var selectedMode: Mode.Kind

    private let services: [any Service]

    init(
        selectedMode: Mode.Kind,
        services: [any Service]
    ) {
        self.selectedMode = selectedMode
        self.services = services
    }

}
