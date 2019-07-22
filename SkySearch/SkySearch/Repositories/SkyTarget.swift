import Foundation
import Alamofire

struct QueryParameters: Encodable, EncodingTrait {
    let country: String
    let currency: String
    let locale: String
    let locationSchema: String
    let originplace: String
    let destinationplace: String
    let outbounddate: String
    let inbounddate: String
    let adults: String
    let apiKey: String = APIConfiguration.apiKey
}

struct PollingParameters: Encodable, EncodingTrait {
    let apiKey: String = APIConfiguration.apiKey
}

enum SkyTarget: Target {
    case prices(QueryParameters)
    case living(URLComponents, PollingParameters)
}

extension SkyTarget {
    var requestURL: URL {
        switch self {
        case .prices:
            let apiKey = URLQueryItem(name: "apiKey", value: APIConfiguration.apiKey)
            var urlComponents = URLComponents()
            urlComponents.host = host
            urlComponents.scheme = "http"
            urlComponents.queryItems = [apiKey]
            urlComponents.path = "/apiservices/pricing/v1.0"

            return urlComponents.url!
        case .living(let urlComponents, _):
            return urlComponents.url!
        }
    }

    var parameters: EncodingTrait {
        switch self {
        case .prices(let parameters):
            return parameters
        case let .living(_, parameters):
            return parameters
        }
    }

    var method: HTTPMethod {
        switch self {
        case .prices:
            return .post
        case .living:
            return .get
        }
    }
}
