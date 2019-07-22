import Foundation

struct Carrier: Decodable {
    let id: Int
    let name: String
    let imageURL: URL

    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case imageURL = "ImageUrl"
        case id = "Id"
    }
}
