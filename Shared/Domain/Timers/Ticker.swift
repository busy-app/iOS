protocol Ticker {
    typealias Callback = (Duration) -> Void

    var callback: Callback { get set }

    func start()
    func pause()
    func resume()
}
