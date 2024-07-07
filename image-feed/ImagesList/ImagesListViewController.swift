import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    //    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    
    private let imagesListService = ImagesListService.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            // полноэкранный режим пока не работает
            let image = UIImage(named: "scribble-placeholder")
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        // картинка
        let photo = photos[indexPath.row]
        guard let imageUrl = URL(string: photo.thumbImageURL) else { return }
        // Kingfisher
        cell.mainImageView.kf.indicatorType = .activity
        cell.mainImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "scribble-placeholder"))
        
        // градиент
        let gradientLayer = CAGradientLayer() // создаём слой градиента
        let gradientHeight = 30.0
        let marginTopAndBottom = 8.0
        gradientLayer.frame = CGRect(x: 0, y: cell.frame.height - gradientHeight - marginTopAndBottom, width: cell.mainImageView.bounds.width, height: gradientHeight) // настраиваем положение слоя
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.ypBlack.withAlphaComponent(0.2).cgColor] // настраиваем цвета слоя
        gradientLayer.locations = [0.0, 1.0]
        cell.mainImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() } // чистим слои
        cell.mainImageView.layer.addSublayer(gradientLayer) // добавляем слой градиента к изображению
        
        // дата
        cell.dateLabel.text = photo.createdAt != nil ? dateFormatter.string(from: photo.createdAt!) : ""
        
        // лайк
        cell.likeButton.setImage(UIImage(named: photo.isLiked ? "heart-red" : "heart-gray"), for: .normal)
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// TableViewDataSource Protocol
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// TableViewDelegate Protocol
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}
