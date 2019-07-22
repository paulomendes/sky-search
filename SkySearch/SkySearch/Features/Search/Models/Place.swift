struct Place: Decodable {
    let code: String
    let name: String
    let id: Int

    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case code = "Code"
        case name = "Name"
    }
}
