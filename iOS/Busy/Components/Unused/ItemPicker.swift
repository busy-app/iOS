import SwiftUI

struct HPicker<Item: Hashable, Content: View>: View {
    @Binding var selection: Item
    let items: [Item]
    @ViewBuilder var content: (Item) -> Content

    init(
        _ value: Binding<Item>,
        in items: [Item],
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self._selection = value
        self.items = items
        self.content = content
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(alignment: .bottom, spacing: 0) {
                    ForEach(items, id: \.self) { item in
                        content(item)
                            .onTapGesture {
                                selection = item
                            }
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, proxy.size.width / 2)
            }
            .picker($selection)
        }
    }
}

private extension ScrollView {
    @MainActor
    func picker(_ value: Binding<some Hashable>) -> some View {
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

private struct ItemPickerModifier<Item: Hashable>: ViewModifier {
    @Binding var selection: Item
    let proxy: ScrollViewProxy

    @State private var position: Item?
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

    HPicker($selection, in: .init(0..<10)) { index in
        VStack {
            Text("\(index)")
        }
        .frame(width: 100)
    }
}
