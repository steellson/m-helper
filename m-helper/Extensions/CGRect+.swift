import CoreGraphics

extension CGRect {
    var randomPoint: CGPoint {
        CGPoint(
            x: .random(in: minX...maxX),
            y: .random(in: minY...maxY)
        )
    }
}
