import WatchKit

var isAppleWatchLarge: Bool {
    WKInterfaceDevice.current().screenBounds.width >= 184
}
