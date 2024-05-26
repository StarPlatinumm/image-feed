import UIKit

final class ProfileViewController: UIViewController {
    
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var idLabel: UILabel?
    private var textLabel: UILabel?
    private var exitButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addProfileImgeView()
        addUserNameLabel("Екатерина Новикова")
        addUserIdLabel("@ekaterinf_nov")
        addUserTextLabel("Hello, World!")
        addExitButton()
    }
    
    private func addProfileImgeView() {
        let imageView = UIImageView(image: UIImage(named: "profile-photo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        self.profileImageView = imageView
    }
    
    private func addUserNameLabel(_ name: String) {
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .ypWhite
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        guard let profileImageView = profileImageView else { return }
        
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        
        self.nameLabel = nameLabel
    }
    
    private func addUserIdLabel(_ id: String) {
        let idLabel = UILabel()
        idLabel.text = id
        idLabel.font = UIFont.systemFont(ofSize: 13)
        idLabel.textColor = .ypDarkGray
        
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(idLabel)
        
        guard let nameLabel else { return }
        
        idLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        self.idLabel = idLabel
    }
    
    private func addUserTextLabel(_ id: String) {
        let textLabel = UILabel()
        textLabel.text = id
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textColor = .ypWhite
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        guard let idLabel else { return }
        
        textLabel.leadingAnchor.constraint(equalTo: idLabel.leadingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 8).isActive = true
        
        self.textLabel = textLabel
    }
    
    private func addExitButton() {
        let exitButton = UIButton(type: .custom)
        exitButton.setImage(UIImage(named: "profile-exit"), for: .normal)
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.exitButton = exitButton
    }
    
    @objc private func exitButtonTapped() {
        print("Exit button tapped!")
    }
}
