import Foundation
import Combine

class ApiManager {
    static let shared = ApiManager()
    private let baseURL = "https://jsonplaceholder.typicode.com/"
    
    private init() {}
    
    func fetchPosts() -> AnyPublisher<[Post], Error>{
        let url = URL(string: "\(baseURL)/posts")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .decode(type: [Post].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchUser(userId: Int)-> AnyPublisher<User,Error>{
        let url = URL(string: "\(baseURL)/users/\(userId)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchComments(postId: Int) -> AnyPublisher<[Comment], Error>{
        let url = URL(string: "\(baseURL)/posts/\(postId)/comments")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Comment].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
