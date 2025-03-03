import Testing
@testable import Busy

struct Tests {
    @Test func example() async throws {
        let state = BusyState(.test)

        #expect(state.current.kind == .work)
    }
}

extension BusySettings {
    static var test: BusySettings {
        .init()
    }
}
