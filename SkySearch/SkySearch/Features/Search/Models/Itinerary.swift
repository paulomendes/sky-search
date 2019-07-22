struct Itinerary: Decodable {
    let outboudLegId: String
    let inboundLegId: String
    let pricingOptions: [PriceOption]

    private enum CodingKeys: String, CodingKey {
        case outboudLegId = "OutboundLegId"
        case inboundLegId = "InboundLegId"
        case pricingOptions = "PricingOptions"
    }
}
