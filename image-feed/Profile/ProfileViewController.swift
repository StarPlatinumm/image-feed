import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .ypDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var exitButton: UIButton  = {
        let exitButton = UIButton(type: .custom)
        exitButton.setImage(UIImage(named: "profile-exit"), for: .normal)
        exitButton.addTarget(ProfileViewController.self, action: #selector(exitButtonTapped), for: .touchUpInside)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        return exitButton
    }()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // получаем данные пользователя
        guard let profileData = profileService.profile else {
            return
        }
        
        // рисуем интерфейс
        addProfileImgeView()
        addUserNameLabel(profileData.name)
        addUserIdLabel(profileData.loginName)
        addUserTextLabel(profileData.bio)
        addExitButton()
        
        // получаем фото пользователя
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let imageUrl = URL(string: profileImageURL)
        else { return }
        // Kingfisher
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        let processor = RoundCornerImageProcessor(cornerRadius: profileImageView.frame.size.width / 2)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: imageUrl, options: [.processor(processor)])
    }
    
    private func addProfileImgeView() {
        view.addSubview(profileImageView)
        
        profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func addUserNameLabel(_ text: String) {
        view.addSubview(nameLabel)
        
        nameLabel.text = text
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addUserIdLabel(_ text: String) {
        view.addSubview(idLabel)
        
        idLabel.text = text
        idLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addUserTextLabel(_ text: String) {
        view.addSubview(textLabel)
        
        textLabel.text = text
        textLabel.leadingAnchor.constraint(equalTo: idLabel.leadingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addExitButton() {
        view.addSubview(exitButton)
        
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc private func exitButtonTapped() {
        print("Exit button tapped!")
    }
}
