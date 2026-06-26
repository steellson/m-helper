import Foundation

enum ServiceType {
    case clicker
    case mover
    case scroller
}

protocol Service {
    var type: ServiceType { get }

    func start()
    func stop()
}
