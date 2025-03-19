import SwiftUI

extension Font {
    enum Variations: Int {
        case weight = 2003265652
        case width = 2003072104
    }

    static func jetBrainsMonoRegular(size: Double) -> Font {
        .custom("JetBrainsMono-Regular", size: size)
    }

    static func pragmaticaNextVF(
        size: Double,
        weight: Double = 500
    ) -> Font {
        let axes = [
            Variations.weight.rawValue: weight
        ]

        let descriptor = UIFontDescriptor(fontAttributes: [
            .name: "PragmaticaNextVF",
            kCTFontVariationAttribute as UIFontDescriptor.AttributeName: axes,
        ])

        return Font(UIFont(descriptor: descriptor, size: size))
    }
}

#Preview {
    @Previewable var weights: [Double] = .init(
        stride(
            from: 100,
            through: 900,
            by: 50
        )
    )

    VStack(spacing: 12) {
        ForEach(weights, id: \.self) { weight in
            Text("BUSY Rest \(weight)")
                .font(.pragmaticaNextVF(size: 24, weight: weight))
                .overlay {
                    Rectangle()
                        .stroke(.red, lineWidth: 2)
                }
        }
    }
}

