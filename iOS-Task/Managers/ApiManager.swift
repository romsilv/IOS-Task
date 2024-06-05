import Foundation
import Alamofire

class ApiManager {
    static let shared = ApiManager()
    private let baseURL = "https://jsonplaceholder.typicode.com/"
    
    private init() {}
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        let url = "\(baseURL)/posts"
        
        AF.request(url).validate().responseDecodable(of: [Post].self) { response in
            guard let posts = try? response.result.get() else {
                if let error = response.error {
                    return completion(.failure(error))
                }
                return
            }
            completion(.success(posts))
        }
    }
    
    func fetchUser(userId: Int, completion: @escaping (Result<User, Error>) -> Void) {
        let url = "\(baseURL)/users/\(userId)"
        
        AF.request(url).validate().responseDecodable(of: User.self) { response in
            guard let user = try? response.result.get() else {
                if let error = response.error {
                    return completion(.failure(error))
                }
                return
            }
            completion(.success(user))
        }
    }
    
    func fetchComments(postId: Int, completion: @escaping (Result<[Comment], Error>) -> Void) {
        let url = "\(baseURL)/posts/\(postId)/comments"
        
        AF.request(url).validate().responseDecodable(of: [Comment].self) { response in
            guard let comments = try? response.result.get() else {
                if let error = response.error {
                    return completion(.failure(error))
                }
                return
            }
            completion(.success(comments))
        }
    }
}
