import RxSwift
import RxCocoa

final class SearchViewModel {
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd., EEE"
        return formatter
    }()

    private let searchRepository: SearchRepositoryType
    private let disposeBag = DisposeBag()

    let rx_tableDataSource: Observable<[ResultCellViewModel]>
    let rx_resultsShown: Driver<String>
    let rx_searchDates: Driver<String>
    let rx_isLoading: Driver<Bool>

    init(searchRepository: SearchRepositoryType) {
        self.searchRepository = searchRepository
        let searchParameters = SearchParameters()

        let flights = searchRepository
            .retrieveFlights(parameters: searchParameters)
            .share()

        let searchResults = flights.map({ (flights) -> [ResultCellViewModel] in
                flights.itineraries.map { ResultCellViewModel(flights: flights, itinerary: $0) }
            })

        self.rx_tableDataSource = searchResults

        self.rx_resultsShown = searchResults
            .map { $0.count }
            .flatMap({ results -> Observable<String> in
                .just("\(results) of \(results) shown")
            })
            .asSharedSequence(onErrorDriveWith: .never())

        let inboundDate = SearchViewModel.dateFormatter.string(from: searchParameters.inboundDate)
        let outboundDate = SearchViewModel.dateFormatter.string(from: searchParameters.outboundDate)

        self.rx_searchDates = .just("\(outboundDate) - \(inboundDate)")

        self.rx_isLoading = flights
            .map { $0.status == .pending }
            .startWith(true)
            .asDriver(onErrorDriveWith: .never())
    }
}
