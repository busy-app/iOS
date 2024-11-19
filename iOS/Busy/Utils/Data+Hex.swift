import Foundation

extension Data {
    var hexString: String {
        return self.reduce(into:"") { result, byte in
            result.append(String(byte >> 4, radix: 16))
            result.append(String(byte & 0x0f, radix: 16))
        }
    }
}
