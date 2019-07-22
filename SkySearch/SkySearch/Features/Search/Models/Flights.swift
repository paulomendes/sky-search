struct Flights: Decodable {
    enum Status: String, Decodable {
        case pending = "UpdatesPending"
        case complete = "UpdatesComplete"
    }

    let itineraries: [Itinerary]
    let places: [Place]
    let legs: [Leg]
    let status: Status
    let carriers: [Carrier]

    private enum CodingKeys: String, CodingKey {
        case itineraries = "Itineraries"
        case status = "Status"
        case places = "Places"
        case legs = "Legs"
        case carriers = "Carriers"
    }
}
