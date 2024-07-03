import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = storage.token {
            fetchProfile(token) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let result):
                    self.fetchProfileImageURL(username: result.username, token: token)
                    self.switchToTabBarController()
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        profileService.fetchProfile(token) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchProfileImageURL(username: String, token: String) {
        profileImageService.fetchProfileImageURL(username: username, token: token) { result in
            switch result {
            case .success(let result):
                print("fetchProfileImageURL: \(result)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func switchToTabBarController() {
        // Получаем экземпляр `window` приложения
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        // Создаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
           
        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Проверим, что переходим на авторизацию
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            
            // Доберёмся до первого контроллера в навигации. Мы помним, что в программировании отсчёт начинается с 0?
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            
            // Установим делегатом контроллера наш SplashViewController
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
           }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        if let token = storage.token {
            fetchProfile(token) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let result):
                    self.fetchProfileImageURL(username: result.username, token: token)
                    self.switchToTabBarController()
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            print("Couldn't read auth token")
        }
    }
}
