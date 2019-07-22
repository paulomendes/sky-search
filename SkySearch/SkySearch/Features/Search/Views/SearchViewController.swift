import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD

final class SearchViewController: UIViewController {
    private let disposeBag = DisposeBag()

    @IBOutlet weak var resultsShown: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchDate: UILabel!

    override func viewDidLoad() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show(withStatus: "Looking for best deals")

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 215
        let repository = SearchRepository(requestProvider: NetworkRequestProvider())
        self.bind(viewModel: SearchViewModel(searchRepository: repository))
    }

    private func bind(viewModel: SearchViewModel) {
        viewModel.rx_tableDataSource
            .bind(to: tableView.rx.items(cellIdentifier: "ResultCell",
                                         cellType: ResultCell.self)) { _, viewModel, cell in
                                            cell.bind(viewModel)
            }
            .disposed(by: disposeBag)

        viewModel.rx_searchDates
            .drive(searchDate.rx.text)
            .disposed(by: disposeBag)

        viewModel.rx_resultsShown
            .drive(resultsShown.rx.text)
            .disposed(by: disposeBag)

        viewModel.rx_isLoading
            .drive(onNext: { isLoading in
                if isLoading == false {
                    SVProgressHUD.dismiss()
                }
            })
            .disposed(by: disposeBag)
    }
}
