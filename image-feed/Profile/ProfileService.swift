import Foundation

final class ProfileService {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastToken != token else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard let request = makeProfileDataRequest(token: token) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let response = try SnakeCaseJSONDecoder().decode(ProfileResult.self, from: data)
                    completion(.success(Profile(
                        username: response.username,
                        name: "\(response.firstName) \(response.lastName)",
                        loginName: "@\(response.username)",
                        bio: response.bio
                    )))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error): completion(.failure(error))
            }
            self?.task = nil
            self?.lastToken = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeProfileDataRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
}
                
