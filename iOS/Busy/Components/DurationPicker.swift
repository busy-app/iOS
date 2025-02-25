import SwiftUI

struct DurationPicker: View {
    @Binding var value: Int
    let values: [Int]

    enum Role {
        case total
        case work
        case rest
        case longRest
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
        self._value = value
        self.values = (allowingInfinity ? [0] : [])
            + .init(
                stride(
                    from: range.lowerBound,
                    through: range.upperBound,
                    by: 5
                )
            )
    }

    var body: some View {
        _DurationPicker(
            value: $value,
            values: values
        )
        .frame(height: 110)
    }
}

private struct _DurationPicker: View {
    @Binding var value: Int
    let values: [Int]

    let spacing = 12.0

    let width = 1.0
    let minorHeight = 16.0
    let majorHeight = 34.0

    var divider: some View {
        Color.white
            .frame(width: width, height: minorHeight)
            .opacity(0.2)
    }

    var dividers: some View {
        HStack(spacing: spacing) {
            divider
            divider
        }
    }

    var body: some View {
        GeometryReader { proxy in
            // TODO: Rewrite ItemPicker to accept [Identifiable & Hashable]
            ItemPicker(
                .init(
                    get: { values.firstIndex(of: value) ?? 0 },
                    set: { value = values[$0] }
                ),
                in: values.indices
            ) { index in
                let isFirst = index == values.startIndex
                let isLast = index == values.endIndex.advanced(by: -1)
                let isInfinity = values[index] == 0
                let isEven = values[index].isMultiple(of: 2)
                let text = String(minutes: values[index])

                VStack {
                    Text(text)
                        .font(.pragmaticaNextVF(size: isInfinity ? 30 : 15))
                        .offset(y: isInfinity ? 12 : 0)
                        .foregroundStyle(.white)
                        .opacityEffect(
                            (isEven || text.count < 5) ? 0.2 : 0.0,
                            center: proxy.frame(in: .global).midX,
                            width: (spacing + width) * 5
                        )
                        .scaleEffect(
                            2.6,
                            center: proxy.frame(in: .global).midX,
                            width: (spacing + width) * 5
                        )
                        .offsetEffect(
                            -36,
                             center: proxy.frame(in: .global).midX,
                             width: (spacing + width) * 5
                        )

                    HStack(spacing: spacing) {
                        dividers
                            .opacity(isFirst ? 0 : 1)

                        Color.whiteInvert
                            .opacityEffect(
                                0.2,
                                center: proxy.frame(in: .global).midX,
                                width: (spacing + width) * 5
                            )
                            .scaleEffect(
                                1.8,
                                center: proxy.frame(in: .global).midX,
                                width: (spacing + width) * 5
                            )
                            .frame(width: width, height: majorHeight)

                        dividers
                            .opacity(isLast ? 0 : 1)
                    }
                }
                .padding(spacing / 2)
            }
        }
    }
}

private extension View {
    func opacityEffect(
        _ value: Double,
        center: Double,
        width: Double
    ) -> some View {
        self.visualEffect { content, proxy in
            let itemCenter = proxy.frame(in: .global).midX
            let factor = max(0.0, 1.0 - abs(itemCenter - center) / width)
            return content.opacity(max(value, 1 * factor))
        }
    }

    func scaleEffect(
        _ value: Double,
        center: Double,
        width: Double
    ) -> some View {
        self.visualEffect { content, proxy in
            let itemCenter = proxy.frame(in: .global).midX
            let factor = max(0.0, 1.0 - abs(itemCenter - center) / width)
            return content.scaleEffect(max(1, value * factor))
        }
    }

    func offsetEffect(
        _ value: Double,
        center: Double,
        width: Double
    ) -> some View {
        self.visualEffect { content, proxy in
            let itemCenter = proxy.frame(in: .global).midX
            let factor = max(0.0, 1.0 - abs(itemCenter - center) / width)
            return content.offset(y: value * factor)
        }
    }
}

#Preview {
    @Previewable @State var total: Int = 90
    @Previewable @State var work: Int = 30
    @Previewable @State var rest: Int = 15
    @Previewable @State var longRest: Int = 35

    VStack {
        Text("Total")
        DurationPicker($total, role: .total)

        Text("Work")
        DurationPicker($work, role: .work)

        Text("Rest")
        DurationPicker($rest, role: .rest)

        Text("Long rest")
        DurationPicker($longRest, role: .longRest)
    }
    .background(.black)
    .colorScheme(.light)
}
