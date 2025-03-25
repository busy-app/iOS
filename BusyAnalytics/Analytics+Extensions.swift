import Foundation

extension TimeInterval {
    var ms: Int64 {
        Int64(self * 1000)
    }
}

extension Duration {
    var ms: Int64 {
        Int64(self.components.seconds * 1000)
    }
}

extension Dictionary {
    func modify(
        _ key: Key,
        _ value: Value
    ) -> [Key: Value] {
        var copy = self
        copy[key] = value
        return copy
    }
}
