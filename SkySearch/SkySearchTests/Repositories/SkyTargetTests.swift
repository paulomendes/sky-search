import Quick
import Nimble
import CoreLocation
@testable import SkySearch

extension QueryParameters {
    static func stub() -> QueryParameters {
        return QueryParameters(country: "UK",
                               currency: "GBP",
                               locale: "en-UK",
                               locationSchema: "Sky",
                               originplace: "EDI",
                               destinationplace: "LHR",
                               outbounddate: "2019-05-13",
                               inbounddate: "2019-05-14",
                               adults: "1")
    }
}


final class SkyTargetTests: QuickSpec {
    override func spec() {
        describe("when dealing with sky target") {
            it("should parse url correctly for prices API") {
                let pricesAPI = SkyTarget.prices(.stub())
                expect(pricesAPI.requestURL.absoluteString).to(equal("http://partners.api.skyscanner.net/apiservices/pricing/v1.0?apiKey=ss630745725358065467897349852985"))
                expect(pricesAPI.method).to(equal(.post))
            }
            it("should parse url correctly for living API") {
                let urlComponents = URLComponents(string: "http://partners.api.skyscanner.net/apiservices/pricing/uk1/v1.0/any-apy-key")!
                let livingAPI = SkyTarget.living(urlComponents, PollingParameters())
                expect(livingAPI.method).to(equal(.get))
                expect(livingAPI.requestURL.absoluteString).to(equal("http://partners.api.skyscanner.net/apiservices/pricing/uk1/v1.0/any-apy-key"))
            }
        }
    }
}
