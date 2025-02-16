import SwiftUI

extension Text {
    init(_ duration: Duration) {
        self.init(duration.hr)
    }
}

extension Text {
    init(_ interval: Interval) {
        self.init(interval.duration.hr)
    }
}

extension BlockerSettings {
    var isAllSelected: Bool {
        categoryTokens.count == 13
    }

    var selectedCountString: String {
        isAllSelected ? "All" : "\(selectedCount)"
    }
}
