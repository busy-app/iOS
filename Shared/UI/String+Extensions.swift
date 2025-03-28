extension String {
    init(minutes totalMinutes: Int) {
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        switch (hours, minutes) {
        case (0, 0): self = "∞"
        case (0, _): self = "\(minutes)m"
        case (_, 0): self = "\(hours)h"
        default: self = "\(hours)h \(minutes)m"
        }
    }
}
