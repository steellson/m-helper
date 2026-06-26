import Foundation

final class Manipulator {
    var selectedMode: Mode.Kind {
        modeStorage.value ?? .allCombined
    }

    var interval: Interval {
        intervalStorage.value ?? .default
    }

    private var activeServices: [any Service] {
        switch selectedMode {
        case .allCombined:
            services
        case .click, .move, .scroll:
            services.filter { $0.type == serviceType(for: selectedMode) }
        }
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
        task?.cancel()
        task = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                self.tick(in: area)

                try? await Task.sleep(
                    for: .seconds(Self.randomDelay(upTo: self.interval.seconds))
                )
            }
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
    func tick(in area: CGRect) {
        activeServices.forEach { $0.act(in: area) }
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
