import Foundation
import RealmSwift

class Post: Object, Decodable,Identifiable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var userId: Int = 0
    @Persisted var title: String = ""
    @Persisted var body: String = ""
}

class FavoritePost: Object {
    @Persisted(primaryKey: true) var postId: Int = 0
}

class DeletedPost: Object {
    @Persisted(primaryKey: true) var postId: Int = 0
}
