import Quick
import Nimble
import CoreLocation
@testable import SkySearch

final class QueryParametersTest: QuickSpec {
    override func spec() {
        describe("When instantiate a Query Parameters") {
            it("it should serialize correctly") {
                let parameters = QueryParameters.stub()
                do {
                    let encoder = JSONEncoder()
                    let json: [String: Any]?

                    let dataEncoded = try encoder.encode(parameters)
                    json = try JSONSerialization.jsonObject(with: dataEncoded, options: .allowFragments) as? [String: Any]

                    expect(json!["apiKey"] as? String).to(equal(APIConfiguration.apiKey))
                } catch {
                    fail()
                }

            }
        }
    }
}
