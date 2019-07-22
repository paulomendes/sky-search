import Foundation
import Alamofire

protocol Target {
    var requestURL: URL { get }
    var method: HTTPMethod { get }
    var parameters: EncodingTrait { get }
    var host: String { get }
}

extension Target {
    var host: String {
        return "partners.api.skyscanner.net"
    }
}
