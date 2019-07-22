import Quick
import Nimble
import CoreLocation
@testable import SkySearch

final class ItineraryTests: QuickSpec {
    override func spec() {
        describe("When dealing with QueryResponse deserealization") {
            it("should parse json correctly") {
                let flights = Flights.stubbed(from: "getPrices")
                expect(flights.status).to(equal(.pending))
                expect(flights.places.count).to(equal(43))
                expect(flights.legs.count).to(equal(114))
                expect(flights.carriers.count).to(equal(15))
                expect(flights.itineraries.count).to(equal(682))

                let firstItinerary = flights.itineraries.first!
                expect(firstItinerary.inboundLegId).to(equal("13554-1905140640--32302-0-11235-1905140825"))
                expect(firstItinerary.outboudLegId).to(equal("11235-1905131735--32302-0-13554-1905131915"))
                expect(firstItinerary.pricingOptions.count).to(equal(11))

                let firstPrice = firstItinerary.pricingOptions.first!
                expect(firstPrice.price).to(beCloseTo(93.06))

                let firstPlace = flights.places.first!
                expect(firstPlace.name).to(equal("Zurich"))
                expect(firstPlace.code).to(equal("ZRH"))

                let firstLeg = flights.legs.first!
                expect(firstLeg.id).to(equal("11235-1905131735--32302-0-13554-1905131915"))
                expect(firstLeg.originStationId).to(equal(11235))
                expect(firstLeg.destinationStationId).to(equal(13554))
                expect(firstLeg.departure).to(equal("2019-05-13T17:35:00"))
                expect(firstLeg.arrival).to(equal("2019-05-13T19:15:00"))
                expect(firstLeg.stops.count).to(equal(0))
                expect(firstLeg.carriers.count).to(equal(1))

                let firstCarrier = flights.carriers.first!
                expect(firstCarrier.name).to(equal("Flybe"))
                expect(firstCarrier.imageURL.absoluteString).to(equal("https://s1.apideeplink.com/images/airlines/BE.png"))
                
            }
        }
    }
}
