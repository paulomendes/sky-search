import Quick
import Nimble
import CoreLocation
import RxTest
import RxSwift
import RxCocoa
@testable import SkySearch

final class NetworkRequestProviderMock<T: Decodable>: NetworkRequestProviderType {
    private let header: URLComponents
    private let signals: [T]
    private var count: Int = 0

    init(header: URLComponents, signals: [T]) {
        self.header = header
        self.signals = signals
    }

    func performRequest<T>(target: Target) -> Single<T> {
        return Single<T>.create { single -> Disposable in
            let returnSignal = self.signals[self.count] as! T
            self.count += 1
            single(.success(returnSignal))

            return Disposables.create { }
        }
    }

    func performRequestForHeader(target: Target) -> Single<URLComponents> {
        return .just(header)
    }
}

final class SearchRepositoryTests: QuickSpec {
    private let testScheduler = TestScheduler(initialClock: 0)
    private let disposeBag = DisposeBag()

    override func spec() {
        describe("When polling for flights") {
            it("should stop when receving complete status") {
                let sequence: [Flights] = [.pending(), .pending(), .complete()]
                let header = URLComponents(string: "http://any.url.com/any-path")!
                let networkRequestProviderMock = NetworkRequestProviderMock(header: header,
                                                                            signals: sequence)
                let searchRepository = SearchRepository(requestProvider: networkRequestProviderMock,
                                                        pollingInterval: 0.1)
                let expectaions = self.expectation(description: "should finish polling")
                expectaions.expectedFulfillmentCount = 3
                var signals: [Flights] = []

                SharingScheduler.mock(scheduler: self.testScheduler) {
                    searchRepository
                        .retrieveFlights(parameters: SearchParameters())
                        .debug()
                        .subscribe(onNext: {
                            signals.append($0)
                            expectaions.fulfill()
                        })
                        .disposed(by: self.disposeBag)
                    self.testScheduler.start()
                }


                self.waitForExpectations(timeout: 1.0, handler: { _ in
                    expect(signals.count).to(equal(3))
                    expect(signals.map { $0.status } ).to(equal([.pending, .pending, .complete]))
                })
            }
        }
    }
}
