import SwiftUI

struct ItemPicker<Content: View>: View {
    @Binding var selection: Int
    let range: Range<Int>
    @ViewBuilder var content: (Int) -> Content

    init(
        _ value: Binding<Int>,
        in range: Range<Int>,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self._selection = value
        self.range = range
        self.content = content
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(alignment: .bottom, spacing: 0) {
                    ForEach(range, id: \.self) { value in
                        content(value)
                            .onTapGesture {
                                selection = value
                            }
                            .id(value)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, proxy.size.width / 2)
            }
            .picker($selection)
        }
    }
}

extension ScrollView {
    func picker(_ value: Binding<Int>) -> some View {
        ScrollViewReader { proxy in
            self
                .modifier(
                    ItemPickerModifier(
                        selection: value,
                        proxy: proxy
                    )
                )
        }
    }
}

struct ItemPickerModifier: ViewModifier {
    @Binding var selection: Int
    let proxy: ScrollViewProxy

    @State private var position: Int?
    @State var scrollToItemWhenIdle: Bool = false

    func body(content: Content) -> some View {
        content
            .defaultScrollAnchor(.center)
            .scrollIndicators(.hidden)
            .scrollPosition(id: $position, anchor: .center)
            .onScrollPhaseChange { oldPhase, newPhase in
                if scrollToItemWhenIdle, newPhase == .idle {
                    scrollToItemWhenIdle = false
                    guard let position else { return }
                    selectionChangedFeedback()
                    withAnimation {
                        proxy.scrollTo(position, anchor: .center)
                    }
                } else if !scrollToItemWhenIdle, newPhase == .interacting {
                    scrollToItemWhenIdle = true
                }
            }
            .onChange(of: selection) { _, _ in
                guard position != selection else { return }
                selectionChangedFeedback()
                withAnimation {
                    proxy.scrollTo(selection, anchor: .center)
                }
            }
            .onChange(of: position) { _, newValue in
                guard let position = newValue else { return }
                selection = position
                selectionChangedFeedback()
            }
            // NOTE: fixes onScrollPhaseChange issue
            .simultaneousGesture(TapGesture().onEnded {
                withAnimation {
                    proxy.scrollTo(selection, anchor: .center)
                }
            })
            .task {
                proxy.scrollTo(selection, anchor: .center)
            }
    }

    private func selectionChangedFeedback() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

#Preview {
    @Previewable @State var selection: Int = 2

    ItemPicker($selection, in: 0..<10) { index in
        VStack {
            Text("\(index)")
        }
        .frame(width: 100)
    }
}
