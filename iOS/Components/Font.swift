import SwiftUI

extension Font {
    static func jetBrainsMonoRegular(size: Double) -> Font {
        .custom("JetBrainsMono-Regular", size: size)
    }

    static func ppNeueMontrealRegular(size: Double) -> Font {
        .custom("PPNeueMontreal-Regular", size: size)
    }

    static func ppNeueMontrealMedium(size: Double) -> Font {
        .custom("PPNeueMontreal-Medium", size: size)
    }

    static func ppNeueMontrealSemiBold(size: Double) -> Font {
        .custom("PPNeueMontreal-SemiBold", size: size)
    }

    static func pragmaticaNextVF(
        size: Double,
        weight: Double = 400
    ) -> Font {
        func fontAxisIdentifier(from axisName: String) -> UInt32 {
            axisName
                .compactMap { $0.asciiValue }
                .reduce(UInt32(0)) { $0 << 8 | UInt32($1) }
        }

        let axes: [UInt32: CGFloat] = [
            fontAxisIdentifier(from: "wght"): CGFloat(weight)
        ]

        let descriptor = UIFontDescriptor(fontAttributes: [
            .name: "PragmaticaNextVF",
            kCTFontVariationAttribute as UIFontDescriptor.AttributeName: axes,
        ])

        return Font(UIFont(descriptor: descriptor, size: size))
    }

    static var titlePrimary: Font {
        .ppNeueMontrealMedium(size: 24)
    }

    static var titleSecondary: Font {
        .ppNeueMontrealMedium(size: 20)
    }

    static var bodyPrimary: Font {
        .ppNeueMontrealRegular(size: 16)
    }

    static var bodySecondary: Font {
        .ppNeueMontrealRegular(size: 14)
    }

    static var labelPrimary: Font {
        .ppNeueMontrealMedium(size: 16)
    }

    static var labelSecondary: Font {
        .ppNeueMontrealMedium(size: 12)
    }

    static var labelLink: Font {
        .ppNeueMontrealMedium(size: 16)
    }

    static var labelBold: Font {
        .ppNeueMontrealSemiBold(size: 16)
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

