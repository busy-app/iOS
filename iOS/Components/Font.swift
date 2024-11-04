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
