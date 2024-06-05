import Foundation

struct Comment: Identifiable, Codable{
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
