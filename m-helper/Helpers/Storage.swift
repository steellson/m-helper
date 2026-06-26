import Foundation

final class Storage<T: RawRepresentable> {
    private let key: String
    private let userDefaults: UserDefaults

    var value: T? {
        guard let raw = userDefaults.object(forKey: key) as? T.RawValue else {
            return nil
        }
        return T(rawValue: raw)
    }

    init(key: String) {
        self.key = key
        self.userDefaults = .standard
    }

    func store(value: T) {
        userDefaults.set(value.rawValue, forKey: key)
    }
}
