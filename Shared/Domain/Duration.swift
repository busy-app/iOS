extension Duration {
    static func minutes(_ minutes: Int) -> Duration {
        .seconds(minutes * 60)
    }

    var minutes: Int {
        Int(components.seconds) / 60
    }

    var seconds: Int {
        Int(components.seconds)
    }
}

extension Duration {
    static var infinity: Duration {
        .seconds(0)
    }
}
