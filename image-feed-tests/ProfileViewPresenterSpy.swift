import image_feed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var didUpdateAvatarCalled: Bool = false
    
    var view: (any image_feed.ProfileViewViewControllerProtocol)?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateAvatar() {
        didUpdateAvatarCalled = true
    }
    
    func logout() {}
}
