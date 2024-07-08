import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private let imagesListService = ImagesListService.shared
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        mainImageView.kf.cancelDownloadTask()
    }
    
    @IBAction func onLikeButtonTapped() {
        guard let photoId = mainImageView.accessibilityLabel else { return } // получаем id фото, спрятанное ранее в accessibilityLabel
        let isLike = likeButton.tag == 0 // если tag равен 0, значит лайка не было и надо лайкнуть
        
        imagesListService.changeLike(photoId: photoId, isLike: isLike) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.likeButton.setImage(UIImage(named: isLike ? "heart-red" : "heart-gray"), for: .normal)
            case .failure(let error): 
                print(error)
            }
        }
    }
    
}
