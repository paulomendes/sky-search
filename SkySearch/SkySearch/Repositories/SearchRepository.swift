import RxSwift

protocol SearchRepositoryType {
    func retrieveFlights(parameters: SearchParameters) -> Observable<Flights>
}

final class SearchRepository: SearchRepositoryType {
    private let requestProvider: NetworkRequestProviderType
    private let pollPauser = BehaviorSubject<Bool>(value: false)
    private let pollingInterval: Double

    init(requestProvider: NetworkRequestProviderType, pollingInterval: Double = 10.0) {
        self.requestProvider = requestProvider
        self.pollingInterval = pollingInterval
    }

    func retrieveFlights(parameters: SearchParameters) -> Observable<Flights> {
        let parameters = QueryParameters(country: "UK",
                                         currency: "GBP",
                                         locale: "en-UK",
                                         locationSchema: "Sky",
                                         originplace: "EDI",
                                         destinationplace: "LHR",
                                         outbounddate: parameters.outboundDateString,
                                         inbounddate: parameters.inboundDateString,
                                         adults: "1")

        let location = self.requestProvider.performRequestForHeader(target: SkyTarget.prices(parameters))
            .asObservable()

        return location.flatMap { location -> Observable<Flights> in
                return self.requestProvider
                    .performRequest(target: SkyTarget.living(location, PollingParameters()))
                    .asObservable()
                    .poll(self.pollingInterval, pauser: self.pollPauser.asObservable())
                    .do(onNext: { self.pollPauser.onNext($0.status == .complete) })
            }
    }
}
