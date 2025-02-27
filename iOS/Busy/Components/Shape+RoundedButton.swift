import SwiftUI

struct RoundedButton: Shape {
    func path(in rect: CGRect) -> Path {
        RoundedRectangle(cornerRadius: 112).path(in: rect)
    }
}
