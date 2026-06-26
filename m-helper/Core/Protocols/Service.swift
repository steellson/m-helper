import Foundation

enum ServiceType {
    case clicker
    case mover
    case scroller
}

protocol Service {
    var type: ServiceType { get }

    func act(in area: CGRect)
}
