struct Leg: Decodable {
    let id: String
    let originStationId: Int
    let destinationStationId: Int
    let departure: String
    let arrival: String
    let stops: [Int]
    let carriers: [Int]

    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case originStationId = "OriginStation"
        case destinationStationId = "DestinationStation"
        case departure = "Departure"
        case arrival = "Arrival"
        case stops = "Stops"
        case carriers = "Carriers"
    }
}
