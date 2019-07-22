import UIKit

final class ResultCellViewModel {
    static private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "GBP"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    static fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter
    }()

    static fileprivate let dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    let inboundAirLogo: URL
    let outboundAirLogo: URL
    let inboundTimes: String
    let outboundTimes: String
    let inboundDuration: String
    let outboundDuration: String
    let price: String
    let inboundLocations: String
    let outboundLocations: String
    let inboundStops: String
    let outboundStops: String

    init(flights: Flights, itinerary: Itinerary) {
        let inboundLeg = flights.leg(for: itinerary.inboundLegId)
        let outboundLeg = flights.leg(for: itinerary.outboudLegId)

        let inboundCarrier = flights.carrier(for: inboundLeg.carriers.first!)
        let outboundCarrier = flights.carrier(for: outboundLeg.carriers.first!)

        self.inboundAirLogo = inboundCarrier.imageURL
        self.outboundAirLogo = outboundCarrier.imageURL
        self.inboundTimes = inboundLeg.formattedTimes()
        self.outboundTimes = outboundLeg.formattedTimes()
        self.inboundDuration = outboundLeg.formattedDuration()
        self.outboundDuration = outboundLeg.formattedDuration()
        self.inboundStops = inboundLeg.formattedStops()
        self.outboundStops = outboundLeg.formattedStops()

        let outboundDestination = flights.place(for: outboundLeg.destinationStationId)
        let outboundOrigin = flights.place(for: outboundLeg.originStationId)
        self.outboundLocations = "\(outboundOrigin.code) - \(outboundDestination.code), \(outboundCarrier.name)"

        let inboundDestination = flights.place(for: inboundLeg.destinationStationId)
        let inboundOrigin = flights.place(for: inboundLeg.originStationId)
        self.inboundLocations = "\(inboundOrigin.code) - \(inboundDestination.code), \(inboundCarrier.name)"

        let price = itinerary.pricingOptions.reduce(0, { ( $0 + $1.price ) }) / Double(itinerary.pricingOptions.count)
        self.price = ResultCellViewModel.numberFormatter.string(from: NSNumber(value: price))!
    }
}


fileprivate extension Leg {
    func formattedTimes() -> String {
        let arrivalDateTime = arrival.toDate()
        let departureDateTime = departure.toDate()
        let formattedArrivalTime = ResultCellViewModel.dateFormatter.string(from: arrivalDateTime)
        let formattedDepartureTime = ResultCellViewModel.dateFormatter.string(from: departureDateTime)

        return "\(formattedDepartureTime) - \(formattedArrivalTime)"
    }

    func formattedDuration() -> String {
        let duration = arrival.toDate().timeIntervalSince(departure.toDate())
        guard let formattedDuration = ResultCellViewModel.dateComponentsFormatter.string(from: duration) else {
            preconditionFailure("No associated duration returned by the request")
        }

        return formattedDuration
    }

    func formattedStops() -> String {
        if stops.count == 0 {
            return "Direct"
        } else {
            return "\(stops.count) Stops"
        }
    }
}

fileprivate extension Flights {
    func leg(for legId: String) -> Leg {
        guard let leg = legs.first(where: { $0.id == legId }) else {
            preconditionFailure("No associated leg returned by the request")
        }

        return leg
    }

    func place(for placeId: Int) -> Place {
        guard let place = places.first(where: { $0.id == placeId }) else {
            preconditionFailure("No associated place returned by the request")
        }

        return place
    }

    func carrier(for carrierId: Int) -> Carrier {
        guard let carrier = carriers.first(where: { $0.id == carrierId }) else {
            preconditionFailure("No associated carrier returned by the request")
        }

        return carrier
    }
}
