import SwiftUI

struct ODurationPicker: View {
    @Binding var value: Int

    private let minutes: [Int]
    private let labels: [String]

    @State private var position = ScrollPosition(idType: Int.self)
    @State private var currentIndex: Int?
    @State private var direction: Direction?
    @State private var allowAnimation = false

    enum Role {
        case total
        case work
        case rest
        case longRest
    }

    enum Direction {
        case left
        case right
    }

    init(_ value: Binding<Duration>, role: Role) {
        let binding: Binding<Int> = .init {
            value.wrappedValue.minutes
        } set: { minutes in
            value.wrappedValue = .minutes(minutes)
        }
        self.init(binding, role: role)
    }

    init(_ value: Binding<Int>, role: Role) {
        switch role {
        case .total: self.init(value, in: 15...(9 * 60), allowingInfinity: true)
        case .work: self.init(value, in: 15...60)
        case .rest: self.init(value, in: 5...15)
        case .longRest: self.init(value, in: 15...30)
        }
    }

    private init(
        _ value: Binding<Int>,
        in range: ClosedRange<Int>,
        allowingInfinity: Bool = false
    ) {
        _value = value

        minutes = (allowingInfinity ? [0] : [])
            + .init(
                    stride(
                        from: range.lowerBound,
                        through: range.upperBound,
                        by: 5
                    )
                )

        labels = minutes.map { totalMinutes in
            let hours = totalMinutes / 60
            let minutes = totalMinutes % 60
            switch (hours, minutes) {
            case (0, 0): return "∞"
            case (0, _): return "\(minutes)m"
            case (_, 0): return "\(hours)h"
            default: return "\(hours)h \(minutes)m"
            }
        }
    }

    var body: some View {
        GeometryReader { outerGeometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(minutes.indices, id: \.self) { index in
                        WheelItem(
                            index: index,
                            text: labels[index],
                            allowAnimation: allowAnimation,
                            isFirst: index == 0,
                            isLast: index == (minutes.count - 1),
                            outerGeometry: outerGeometry,
                            onTap: { onTap(by: index) }
                        )
                        .id(index)
                        .frame(width: itemWidth, height: itemHeight)
                    }
                }
                .padding(.top, 45)
                .padding(.bottom, 8)
                .padding(
                    .horizontal,
                    (outerGeometry.size.width - itemWidth) / 2
                )
                .scrollTargetLayout()
            }
            .scrollPosition(
                $position,
                anchor: .init(x: 0.5, y: 0)
            )
            .scrollTargetBehavior(
                TargetBehavior(
                    itemCount: minutes.count,
                    itemWidth: itemWidth,
                    direction: direction
                )
            )
            .onChange(of: position) {
                guard let index = position.viewID as? Int else { return }
                value = minutes[index]

                if index != currentIndex {
                    let generator = UISelectionFeedbackGenerator()
                    generator.selectionChanged()
                    currentIndex = index
                }
            }
            .onAppear {
                let index = minutes.firstIndex(of: value) ?? 0
                currentIndex = index
                position.scrollTo(id: index, anchor: .center)
                Task {
                    try await Task.sleep(nanoseconds: 500_000)
                    allowAnimation = true
                }
            }
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        let horizontal = value.translation.width
                        direction = horizontal > 0 ? .right : .left
                    }
            )
        }
        .background(.transparentBlackInvertSecondary)
        .frame(height: 150)
    }

    private func onTap(by index: Int) {
        withAnimation {
            position.scrollTo(id: index, anchor: .center)
        }
    }
}

private struct TargetBehavior: ScrollTargetBehavior {
    let itemCount: Int
    let itemWidth: CGFloat
    let direction: ODurationPicker.Direction?

    private var fraction: Double { 0.4 }

    func updateTarget(
        _ target: inout ScrollTarget,
        context: ScrollTargetBehaviorContext
    ) {
        guard let direction = direction else { return }

        let scrollViewMidX = context.containerSize.width / 2
        let itemViewMidX = target.rect.midX
        let rawIndex = (itemViewMidX - scrollViewMidX) / itemWidth

        let currentIndex: Int
        switch direction {
          case .right: currentIndex = Int(floor(rawIndex))
          case .left: currentIndex = Int(ceil(rawIndex))
        }

        let diffIndex = rawIndex - Double(currentIndex)
        var newIndex = Double(currentIndex)
        switch direction {
        case .right:
            if diffIndex > fraction {
                newIndex += 1
            }
        case .left:
            if diffIndex < fraction - 1 {
                newIndex -= 1
            }
        }

        newIndex = max(0, min(Double(itemCount - 1), newIndex))
        let desiredCenterX = scrollViewMidX + (newIndex * itemWidth)

        target.rect.origin.x = desiredCenterX - target.rect.width / 2
        target.anchor = .center
    }
}

private struct WheelItem: View {
    let index: Int
    let text: String

    let allowAnimation: Bool

    let isFirst: Bool
    let isLast: Bool

    let outerGeometry: GeometryProxy
    let onTap: () -> Void

    private var animation: Animation? {
        allowAnimation ? .spring() : nil
    }

    var body: some View {
        GeometryReader { innerGeometry in
            let distance = calculateDistance(in: innerGeometry)
            let scale = calculateDynamicScale(for: distance)
            let opacity = calculateOpacity(for: distance)

            // Increase the scale for infinite symbol
            let textScale = text == "∞" ? scale * 2 : scale
            let textOpacity = calculateTextOpacity(for: scale)

            // Offset text up
            let yOffset = (scale - 1) * -50

            VStack(spacing: 0) {
                Text(text)
                    .foregroundStyle(.whiteInvert.opacity(opacity))
                    .font(.pragmaticaNextVF(size: 20, weight: 500))
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .center
                    )
                    .scaleEffect(textScale, anchor: .center)
                    .offset(y: yOffset)
                    .animation(animation, value: scale)
                    .opacity(textOpacity)
                    .contentShape(Rectangle())
                    .onTapGesture { onTap() }

                HStack(spacing: 0) {
                    secondaryDivider()
                        .opacity(isFirst ? 0 : 1)

                    secondaryDivider()
                        .padding(.leading, dividerSpacing)
                        .opacity(isFirst ? 0 : 1)

                    primaryDivider(opacity: opacity)
                        .padding(.horizontal, dividerSpacing)
                        .scaleEffect(scale, anchor: .center)

                    secondaryDivider()
                        .padding(.trailing, dividerSpacing)
                        .opacity(isLast ? 0 : 1)

                    secondaryDivider()
                        .opacity(isLast ? 0 : 1)
                }
            }
        }
    }

    @ViewBuilder private func secondaryDivider() -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(.whiteInvert.opacity(0.2))
            .frame(
                width: dividerWidth,
                height: secondaryDividerHeight
            )
    }

    @ViewBuilder private func primaryDivider(opacity: Double) -> some View {
        let fraction = calculateDividerFraction(for: opacity)
        let color = Color.whiteInvert.mix(with: .accent, by: fraction)

        RoundedRectangle(cornerRadius: 2)
            .fill(color.opacity(opacity))
            .frame(
                width: dividerWidth,
                height: primaryDividerHeight
            )
            .animation(.spring(), value: color)
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

    private func calculateDividerFraction(for opacity: CGFloat) -> CGFloat {
        min(1.0, max(0.0, (opacity - 0.4) * 2))
    }

    private func calculateTextOpacity(for scale: CGFloat) -> CGFloat {
        guard text.count >= 4 else { return 1.0 }

        return index % 2 == 1
            ? scale > 1.1
                ? 1.0
                : 0.0
            : 1.0
    }
}

fileprivate extension View {
    var scrollSpace: String { "TimePickerScroll" }

    var itemHeight: CGFloat { 80 }
    var itemWidth: CGFloat {
        dividerSpacing * dividerCount + dividerWidth * dividerCount
    }

    var primaryDividerHeight: CGFloat { 32 }
    var secondaryDividerHeight: CGFloat { 16 }

    var dividerWidth: CGFloat { 2 }
    var dividerCount: CGFloat { 5 }
    var dividerSpacing: CGFloat { 16 }
}

#Preview {
    @Previewable @State var total: Int = 90
    @Previewable @State var work: Int = 30
    @Previewable @State var rest: Int = 15
    @Previewable @State var longRest: Int = 35

    VStack {
        Text("Total")
        ODurationPicker($total, role: .total)

        Text("Work")
        ODurationPicker($work, role: .work)

        Text("Rest")
        ODurationPicker($rest, role: .rest)

        Text("Long rest")
        ODurationPicker($longRest, role: .longRest)
    }
    .background(.black)
    .colorScheme(.light)
}
