import Foundation

extension RawRepresentable where Self: Codable {
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self) else { return "" }
        return String(decoding: data, as: UTF8.self)
    }

    init?(rawValue: String) {
        guard
            let value = try? JSONDecoder().decode(
                Self.self,
                from: .init(rawValue.utf8)
            )
        else {
            return nil
        }
        self = value
    }
}
