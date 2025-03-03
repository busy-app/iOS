import SwiftUI

extension Text {
    init(_ duration: Duration) {
        self.init(String(minutes: duration.seconds / 60))
    }
}

extension Text {
    init(_ interval: Interval) {
        self.init(interval.duration)
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
