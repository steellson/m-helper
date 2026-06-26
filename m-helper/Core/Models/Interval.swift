import Foundation

struct Interval: RawRepresentable, Equatable {
    static let step = 60
    static let minimum = 60
    static let maximum = 600

    static let `default` = Interval(rawValue: 60)

    let rawValue: Int

    init(rawValue: Int) {
        let aligned = rawValue / Self.step * Self.step
        self.rawValue = min(
            max(aligned, Self.minimum),
            Self.maximum
        )
    }
}

extension Interval {
    var seconds: TimeInterval { TimeInterval(rawValue) }

    var title: String {
        let minutes = rawValue / 60
        let seconds = rawValue % 60

        switch (minutes, seconds) {
        case (0, _):  return "\(seconds)s"
        case (_, 0):  return "\(minutes)m"
        default:      return "\(minutes)m \(seconds)s"
        }
    }

    func adding(_ value: Int) -> Interval {
        Interval(rawValue: rawValue + value)
    }
}
