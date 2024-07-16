import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private let imagesListService = ImagesListService.shared
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        mainImageView.kf.cancelDownloadTask()
    }
    
    func setIsLiked(_ isLiked: Bool) {
        likeButton.setImage(UIImage(named: isLiked ? "heart-red" : "heart-gray"), for: .normal)
    }
    
    @IBAction func onLikeButtonTapped() {
        delegate?.imageListCellDidTapLike(self)
    }
    
}
