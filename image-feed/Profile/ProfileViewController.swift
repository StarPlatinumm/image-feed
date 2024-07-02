import UIKit

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService()
    
    private var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profile-photo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var idLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterinf_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .ypDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tokenStorage = OAuth2TokenStorage()
        guard let token = tokenStorage.token else {
            // добавить описание ошибки
            return
        }
        print(token)
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profileData):
                self.addProfileImgeView()
                self.addUserNameLabel(profileData.name)
                self.addUserIdLabel(profileData.loginName)
                self.addUserTextLabel(profileData.bio)
                self.addExitButton()
            case .failure(let error):
                print(error)
            }
        }
        
        
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
