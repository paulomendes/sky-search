import Quick
import Nimble
import CoreLocation
@testable import SkySearch

final class ResultCellViewModelTests: QuickSpec {
    override func spec() {
        describe("When initializing viewModel") {
            it("should parse from model correctly") {
                let flights = Flights.stubbed(from: "getPrices")
                let itinerary = flights.itineraries.first!
                let viewModel = ResultCellViewModel(flights: flights, itinerary: itinerary)

                expect(viewModel.inboundTimes).to(equal("03:40 - 05:25"))
                expect(viewModel.outboundTimes).to(equal("02:35 - 04:15"))
                expect(viewModel.inboundLocations).to(equal("LHR - EDI, Flybe"))
                expect(viewModel.outboundLocations).to(equal("EDI - LHR, Flybe"))
                expect(viewModel.price).to(equal("£115.25"))
                expect(viewModel.inboundAirLogo.absoluteString).to(equal("https://s1.apideeplink.com/images/airlines/BE.png"))
                expect(viewModel.outboundAirLogo.absoluteString).to(equal("https://s1.apideeplink.com/images/airlines/BE.png"))
                expect(viewModel.inboundDuration).to(equal("1h 40m"))
                expect(viewModel.outboundDuration).to(equal("1h 40m"))
                expect(viewModel.outboundStops).to(equal("Direct"))
                expect(viewModel.inboundStops).to(equal("Direct"))
            }
        }
    }
}
