struct PriceOption: Decodable {
    let price: Double

    private enum CodingKeys: String, CodingKey {
        case price = "Price"
    }
}
