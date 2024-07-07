import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage() {
        guard task == nil else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makePhotosRequest(page: nextPage, perPage: 10) else {
            print("Failed to make photos request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let newPhotos):
                addToPhotos(newPhotos: newPhotos)
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["Photos": photos]
                )
            case .failure(let error): print(error)
            }
            self.task = nil
            self.lastLoadedPage = nextPage
        }
        self.task = task
        task.resume()
    }
    
    private func makePhotosRequest(page: Int, perPage: Int) -> URLRequest? {
        guard let baseURL = URL(string: "https://api.unsplash.com") else { return nil }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path = "/photos"
        
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        components?.queryItems = queryItems
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    private func addToPhotos(newPhotos: [PhotoResult]) {
        let dateFormatter = DateFormatter()
        
        for photo in newPhotos {
            let newPhoto = Photo(
                id: photo.id,
                size: CGSize(width: photo.width, height: photo.height),
                createdAt: dateFormatter.date(from: photo.createdAt),
                welcomeDescription: photo.description,
                thumbImageURL: photo.urls.thumb,
                largeImageURL: photo.urls.full,
                isLiked: false
            )
            photos.append(newPhoto)
        }
    }
}

