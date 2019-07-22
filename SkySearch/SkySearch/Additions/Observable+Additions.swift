import RxSwift

extension ObservableType {
    func poll(_ interval: TimeInterval,
              scheduler: SchedulerType = SerialDispatchQueueScheduler(qos: .default),
              pauser: Observable<Bool> = .just(false)) -> Observable<E> {
        let polling = Observable<Int>
            .interval(interval, scheduler: scheduler)
            .filter(if: pauser.map { !$0 }.startWith(true))
            .flatMapLatest { _ in self }

        return concat(polling)
    }
}

extension ObservableType {
    // FilterIf: Filters the source observable sequence using a trigger observable sequence producing Bool values.
    // more 👉 https://gist.github.com/danielt1263/1a70c4f7b8960d06bd7f1bfa81802cc3
    func filter<O>(if trigger: O) -> Observable<E> where O: ObservableType, O.E == Bool {
        return withLatestFrom(trigger) { ($0, $1) }
            .filter { $0.1 }
            .map { $0.0 }
    }
}

