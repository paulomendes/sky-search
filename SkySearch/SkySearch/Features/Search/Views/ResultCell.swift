import UIKit
import SDWebImage

final class ResultCell: UITableViewCell {
    @IBOutlet weak var inboundAirLogo: UIImageView!
    @IBOutlet weak var outboundAirLogo: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var inboundTimes: UILabel!
    @IBOutlet weak var outboundTimes: UILabel!
    @IBOutlet weak var inboundLocation: UILabel!
    @IBOutlet weak var outboundLocation: UILabel!
    @IBOutlet weak var inboundStops: UILabel!
    @IBOutlet weak var outboundStops: UILabel!
    @IBOutlet weak var inboundDuration: UILabel!
    @IBOutlet weak var outboundDuration: UILabel!

    func bind(_ viewModel: ResultCellViewModel) {
        inboundAirLogo.sd_setImage(with: viewModel.inboundAirLogo, placeholderImage: UIImage(named: "placeholder-logo"))
        outboundAirLogo.sd_setImage(with: viewModel.outboundAirLogo, placeholderImage: UIImage(named: "placeholder-logo"))
        price.text = viewModel.price
        inboundTimes.text = viewModel.inboundTimes
        outboundTimes.text = viewModel.outboundTimes
        inboundLocation.text = viewModel.inboundLocations
        outboundLocation.text = viewModel.outboundLocations
        inboundStops.text = viewModel.outboundStops
        outboundStops.text = viewModel.outboundStops
        inboundDuration.text = viewModel.inboundDuration
        outboundDuration.text = viewModel.outboundDuration
    }
}
