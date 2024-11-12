import SwiftUI

// NOTE: One color, becuase it's a overlapping circles
struct AnimatedLoader: View {
    let color: Color

    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: 1)
                .stroke(color, lineWidth: 2)

            Circle()
                .trim(from: 0.0, to: 0.25)
                .stroke(color, lineWidth: 2)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .onAppear {
                    withAnimation(
                        .linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                    ) {
                        isAnimating.toggle()
                    }
                }
        }
    }
}

struct AnimatedCircleView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedLoader(color: .whiteInvert)
            .frame(width: 24, height: 24)
            .opacity(0.5)
            .background(Color.black)
    }
}
