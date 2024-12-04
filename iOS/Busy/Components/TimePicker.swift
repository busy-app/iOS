import SwiftUI

struct TimePicker: View {
    @Binding var minute: Int
    @Binding var second: Int

    var itemsCount: Double { 5 }

    var body: some View {
        GeometryReader { proxy in
            let itemHeight = (proxy.size.height / itemsCount)

            HStack(spacing: 0) {
                Image(uiImage: .triangle)

                TimePickerComponent(
                    selection: $minute,
                    kind: .minute
                ) { item in
                    HStack {
                        Spacer()
                        Text(String(format:"%02d", item))
                            .frame(height: itemHeight)
                    }
                }

                Text(":")
                    .frame(height: proxy.size.height / itemsCount)

                TimePickerComponent(
                    selection: $second,
                    kind: .second
                ) { item in
                    HStack {
                        Text(String(format: "%02d", item))
                            .frame(height: itemHeight)
                        Spacer()
                    }
                }

                Image(uiImage: .triangle)
                    .rotationEffect(.degrees(180))
            }
            .gradientMask()
        }
    }
}

struct TimePickerComponent<Content: View>: View {
    @Binding var selection: Int
    let kind: Kind
    @ViewBuilder var content: (Int) -> Content

    @State private var position: Int?

    @State var shouldScroll: Bool = false
    @State var scrollTask: Task<Void, Swift.Error>? = nil

    enum Kind {
        case hour
        case minute
        case second

        var divider: Int {
            switch self {
            case .hour: return 24
            case .minute: return 60
            case .second: return 60
            }
        }
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollViewReader { reader in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(0 ..< 600) { value in
                            content(value % kind.divider)
                                .onTapGesture {
                                    selection = value % kind.divider
                                    withAnimation {
                                        reader.scrollTo(value, anchor: .center)
                                    }
                                }
                                .opacityEffect(proxy.frame(in: .global).midY)
                                .id(value)
                        }
                    }
                    .scrollTargetLayout()
                }
                .defaultScrollAnchor(.center)
                .scrollIndicators(.hidden)
                .scrollPosition(id: $position, anchor: .center)
                .onScrollPhaseChange { oldPhase, newPhase in
                    if shouldScroll, newPhase == .idle {
                        shouldScroll = false
                        UISelectionFeedbackGenerator().selectionChanged()
                        withAnimation {
                            reader.scrollTo(position, anchor: .center)
                        }
                    } else if !shouldScroll, newPhase == .interacting {
                        shouldScroll = true
                    }
                }
                .onScrollTargetVisibilityChange(idType: Int.self) { id in
                    if id.contains(0) {
                        scrollToSelection(reader: reader)
                    }
                }
                .onChange(of: position) { _, newValue in
                    UISelectionFeedbackGenerator().selectionChanged()
                    guard let position = newValue else { return }
                    selection = position % kind.divider
                }
                .task {
                    scrollToSelection(reader: reader)
                }
            }
        }
    }

    private func scrollToSelection(reader: ScrollViewProxy) {
        let zero = 600 / 2 - (600 / 2 % kind.divider)
        reader.scrollTo(zero + selection, anchor: .center)
    }
}

private extension View {
    func opacityEffect(_ containerCenter: Double) -> some View {
        self.visualEffect { content, proxy in
            let center = proxy.frame(in: .global).midY
            let height = proxy.size.height
            return content
                .opacity(max(0.1, 1.0 - abs(center - containerCenter) / height))
        }
    }

    func gradientMask() -> some View {
        self.mask {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .white.opacity(0), location: 0.00),
                    Gradient.Stop(color: .white, location: 0.35),
                    Gradient.Stop(color: .white, location: 0.65),
                    Gradient.Stop(color: .white.opacity(0), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        }
    }
}
