import Foundation

final class Manipulator {
    var selectedMode: Mode.Kind {
        modeStorage.value ?? .allCombined
    }

    var interval: Interval {
        intervalStorage.value ?? .default
    }

    private let modeStorage: Storage<Mode.Kind>
    private let intervalStorage: Storage<Interval>
    private let services: [any Service]
    private var task: Task<Void, Never>?

    init(
        modeStorage: Storage<Mode.Kind>,
        intervalStorage: Storage<Interval>,
        services: [any Service]
    ) {
        self.modeStorage = modeStorage
        self.intervalStorage = intervalStorage
        self.services = services
    }

    deinit {
        task?.cancel()
    }
}

// MARK: - Public
extension Manipulator {
    func start(with area: CGRect) {
        switch selectedMode {
        case .click, .move, .scroll:
            launchSingleMode(with: area)
        case .allCombined:
            launchCombinedMode(with: area)
        }
    }

    func stop() {
        task?.cancel()
        task = nil
    }

    func change(mode: Mode.Kind) {
        modeStorage.store(value: mode)
    }

    func change(interval: Interval) {
        intervalStorage.store(value: interval)
    }
}

// MARK: - Private
private extension Manipulator {
    func launchSingleMode(with area: CGRect) {
        let target = services.first {
            $0.type == serviceType(for: selectedMode)
        }

        guard let target else { return }
        loop { target.act(in: area) }
    }

    func launchCombinedMode(with area: CGRect) {
        loop { [weak self] in
            self?.services.forEach { $0.act(in: area) }
        }
    }

    func loop(_ action: @escaping () -> Void) {
        task?.cancel()

        let seconds = interval.seconds
        task = Task {
            while !Task.isCancelled {
                action()
                try? await Task.sleep(
                    for: .seconds(Self.randomDelay(upTo: seconds))
                )
            }
        }
    }

    func serviceType(for mode: Mode.Kind) -> ServiceType? {
        switch mode {
        case .click:       .clicker
        case .move:        .mover
        case .scroll:      .scroller
        case .allCombined: nil
        }
    }

    static func randomDelay(
        upTo interval: TimeInterval
    ) -> TimeInterval {
        interval * max(
            Double.random(in: 0...1),
            Double.random(in: 0...1)
        )
    }
}
