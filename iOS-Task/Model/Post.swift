import Foundation

struct Post: Codable, Identifiable{
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

struct User: Identifiable, Codable{
    let id: Int
    let name: String
    let username: String
    let email: String
}

struct Comment: Identifiable, Codable{
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
