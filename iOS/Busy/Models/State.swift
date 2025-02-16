struct BusyState {
    var isRunning: Bool = false
    var cycle: Cycle = .init()

    struct Cycle {
        var count: Int = 3
        var current: Int = 0
    }
}
