import SwiftUI

struct TimePickerWheel: View {
    let minutes: [Int]
    @Binding var current: Int

    private var timeLabels: [String] {
        minutes.map { totalMinutes in
            let hours = totalMinutes / 60
            let minutes = totalMinutes % 60
            if hours > 0 {
                return "\(hours)h \(minutes)m"
            } else {
                return "\(minutes)m"
            }
        }
    }

    var body: some View {
        GeometryReader { outerGeometry in
            ScrollViewReader { scrollProxy in
                TimeWheelScrollView(
                    items: timeLabels,
                    outerGeometry: outerGeometry,
                    scrollProxy: scrollProxy,
                    onSelectedIndexChange: onUpdateTime
                )
                .onChange(of: current, initial: true) { old, new in
                    let index = minutes.firstIndex(of: current) ?? 0
                    withAnimation {
                        scrollProxy.scrollTo(index, anchor: .center)
                    }
                }
            }
        }
        .background(.blackInvert)
        .frame(height: 150)
    }

    private func onUpdateTime(_ index: Int) {
        current = minutes[index]
    }
}

private struct TimeWheelScrollView: View {
    let items: [String]

    let outerGeometry: GeometryProxy
    let scrollProxy: ScrollViewProxy

    let onSelectedIndexChange: (Int) -> Void

    @State private var centerPositions: [Int: CGFloat] = [:]
    @State private var lastFeedbackIndex: Int? = nil

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    TimeWheelItem(
                        index: index,
                        text: items[index],
                        isFirst: index == 0,
                        isLast: index == (items.count - 1),
                        outerGeometry: outerGeometry,
                        onTap: { onSelectedIndexChange(index) }
                    )
                    .frame(width: itemWidth, height: itemHeight)
                }
            }
            .padding(.top, 45)
            .padding(.horizontal, (outerGeometry.size.width - itemWidth) / 2)
        }
        .coordinateSpace(name: scrollSpace)
        .onPreferenceChange(CenterPositionKey.self) {
            centerPositions = $0

            guard let nearest = findNearestIndex() else { return }
            selectionFeedback(index: nearest)
        }
        .simultaneousGesture(
            DragGesture()
                .onEnded { _ in
                    Task { @MainActor in
                        try await Task.sleep(nanoseconds: 200_000_000)
                        guard let index = findNearestIndex() else { return }
                        onSelectedIndexChange(index)
                    }
            }
        )
    }

    private func findNearestIndex() -> Int? {
        let centerX = outerGeometry.size.width / 2

        return centerPositions
            .min { abs($0.value - centerX) < abs($1.value - centerX) }?
            .key
    }

    private func selectionFeedback(index: Int) {
        if index != lastFeedbackIndex {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            lastFeedbackIndex = index
        }
    }
}

private struct TimeWheelItem: View {
    let index: Int
    let text: String

    let isFirst: Bool
    let isLast: Bool

    let outerGeometry: GeometryProxy
    let onTap: () -> Void

    var body: some View {
        GeometryReader { innerGeometry in
            let distance = calculateDistance(in: innerGeometry)
            let scale = calculateDynamicScale(for: distance)
            let opacity = calculateOpacity(for: distance)

            // Increase the scale for infinite symbol
            let text = isFirst ? "∞" : text
            let textScale = isFirst ? scale * 2 : scale

            // Hide even text in default state
            let textOpacity = index % 2 == 1
                ? scale > 1.1
                    ? 1.0
                    : 0.0
                : 1.0

            // Offset text up
            let yOffset = (scale - 1) * -60

            VStack(spacing: 0) {
                Text(text)
                    .foregroundStyle(.whiteInvert.opacity(opacity))
                    .font(.ppNeueMontrealMedium(size: 20))
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .center
                    )
                    .scaleEffect(textScale, anchor: .center)
                    .offset(y: yOffset)
                    .animation(.spring(), value: scale)
                    .opacity(textOpacity)
                    .onTapGesture { onTap() }
                    .background(
                        GeometryReader {
                            let midX = $0.frame(in: .named(scrollSpace)).midX

                            Color
                                .clear
                                .preference(
                                    key: CenterPositionKey.self,
                                    value: [index: midX]
                                )
                        }
                    )

                HStack(spacing: 0) {
                    divider(height: secondaryDividerHeight)
                        .opacity(isFirst ? 0 : 1)

                    divider(height: secondaryDividerHeight)
                        .padding(.leading, dividerSpacing)
                        .opacity(isFirst ? 0 : 1)

                    divider(height: primaryDividerHeight, opacity: opacity)
                        .padding(.horizontal, dividerSpacing)

                    divider(height: secondaryDividerHeight)
                        .padding(.trailing, dividerSpacing)
                        .opacity(isLast ? 0 : 1)

                    divider(height: secondaryDividerHeight)
                        .opacity(isLast ? 0 : 1)
                }
            }
        }
    }

    @ViewBuilder private func divider(
        height: CGFloat,
        opacity: Double = 0.2
    ) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(.whiteInvert.opacity(opacity))
            .frame(
                width: dividerWidth,
                height: height
            )
    }

    private func calculateDistance(in inner: GeometryProxy) -> CGFloat {
        let midX = inner.frame(in: .named(scrollSpace)).midX
        let centerX = outerGeometry.size.width / 2
        return abs(midX - centerX)
    }

    private func calculateOpacity(for distance: CGFloat) -> Double {
        max(0.2, 1 - (distance / 50 * 0.8))
    }

    private func calculateDynamicScale(for distance: CGFloat) -> CGFloat {
        max(1, 1.5 - distance / 150)
    }
}

private struct CenterPositionKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]

    static func reduce(
        value: inout [Int: CGFloat],
        nextValue: () -> [Int: CGFloat]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

fileprivate extension View {
    var scrollSpace: String { "TimePickerScroll" }

    var itemHeight: CGFloat { 80 }
    var itemWidth: CGFloat { 80 }

    var primaryDividerHeight: CGFloat { 50 }
    var secondaryDividerHeight: CGFloat { 28 }

    var dividerWidth: CGFloat { 2 }
    var dividerCount: CGFloat { 5 }
    var dividerSpacing: CGFloat {
        (itemWidth - dividerCount * dividerWidth) / dividerCount
    }
}

#Preview {
    @Previewable @State var currentMinute: Int = 0

    var minutes: [Int] {
        return Array(stride(from: 0, through: 540, by: 5))
    }

    VStack {
        TimePickerWheel(minutes: minutes, current: $currentMinute)
            .colorScheme(.dark)

        TimePickerWheel(minutes: minutes, current: $currentMinute)
            .colorScheme(.light)
    }
}
