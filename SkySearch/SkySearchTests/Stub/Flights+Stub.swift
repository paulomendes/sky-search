import Foundation
@testable import SkySearch

extension Flights {
    static func pending() -> Flights {
        return Flights(itineraries: [], places: [], legs: [], status: .pending, carriers: [])
    }

    static func complete() -> Flights {
        return Flights(itineraries: [], places: [], legs: [], status: .complete, carriers: [])
    }
}
