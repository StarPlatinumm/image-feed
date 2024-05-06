//
//  ViewController.swift
//  image-feed
//
//  Created by Артем Кривдин on 05.05.2024.
//

import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        // картинка
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        cell.mainImageView.image = image
        
        // градиент
        let gradientLayer = CAGradientLayer() // создаём слой градиента
        gradientLayer.frame = CGRect(x: 0, y: cell.frame.height - 50, width: cell.mainImageView.bounds.width, height: 30) // настраиваем положение слоя
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.5).cgColor] // настраиваем цвета слоя
        gradientLayer.locations = [0.0, 1.0]
        cell.mainImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() } // чистим слои
        cell.mainImageView.layer.addSublayer(gradientLayer) // добавляем слой градиента к изображению
        
        // дата
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        // лайк
        cell.likeButton.setImage(UIImage(named: indexPath.row % 2 == 0 ? "heart-red" : "heart-gray"), for: .normal)
    }
    
}

// TableViewDataSource Protocol
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
