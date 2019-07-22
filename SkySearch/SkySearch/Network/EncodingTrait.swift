import Foundation

protocol EncodingTrait {
    func encode() throws -> [String: Any]?
}

extension EncodingTrait where Self: Encodable {
    func encode() throws -> [String: Any]? {
        let encoder = JSONEncoder()
        let parameters: [String: Any]?

        do {
            let dataEncoded = try encoder.encode(self)
            parameters = try JSONSerialization.jsonObject(with: dataEncoded, options: .allowFragments) as? [String: Any]
        } catch {
            throw error
        }

        return parameters
    }
}

