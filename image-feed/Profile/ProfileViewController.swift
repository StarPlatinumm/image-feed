import UIKit

final class ProfileViewController: UIViewController {
    
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
        
        addProfileImgeView()
        addUserNameLabel()
        addUserIdLabel()
        addUserTextLabel()
        addExitButton()
    }

    private func addProfileImgeView() {
        view.addSubview(profileImageView)
        
        profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func addUserNameLabel() {
        view.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addUserIdLabel() {
        view.addSubview(idLabel)
        
        idLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addUserTextLabel() {
        view.addSubview(textLabel)
        
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
