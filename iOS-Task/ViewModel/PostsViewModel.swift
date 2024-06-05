import Foundation
import Alamofire
import RealmSwift

class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var errorMessage: String?
    @Published var favorites: Set<Int> = []
    @Published var deletedPosts: Set<Int> = []
    @Published var isLoading: Bool = false
    
    private var realm: Realm

    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("failed to open Realm DB")
        }
        
        loadFavorites()
        loadDeletedPosts()
    }
    
    func fetchPosts() {
        guard NetworkReachabilityManager()?.isReachable == true else {
            self.errorMessage = "No internet connection."
            return
        }
        
        isLoading = true
        ApiManager.shared.fetchPosts { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let posts):
                self.posts = posts.filter { !self.deletedPosts.contains($0.id) }
            case .failure(let error):
                if let afError = error as? AFError {
                    switch afError {
                    case .sessionTaskFailed(let urlError as URLError) where urlError.code == .notConnectedToInternet:
                        self.errorMessage = "No internet connection."
                    case .responseSerializationFailed(reason: .inputDataNilOrZeroLength):
                        self.errorMessage = "Received empty response."
                    default:
                        self.errorMessage = "An unexpected error occurred: \(afError.localizedDescription)"
                    }
                } else {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func toggleFavorite(postId: Int) {
        do {
            try realm.write {
                if favorites.contains(postId) {
                    guard let favoritePost = realm.object(ofType: FavoritePost.self, forPrimaryKey: postId) else { return }
                    realm.delete(favoritePost)
                    favorites.remove(postId)
                } else {
                    let favoritePost = FavoritePost()
                    favoritePost.postId = postId
                    realm.add(favoritePost)
                    favorites.insert(postId)
                }
            }
        } catch {
            print("error toggling favorite")
        }
    }
    
    func removePost(postId: Int) {
        do {
            try realm.write {
                posts.removeAll { $0.id == postId }
                
                if let post = realm.object(ofType: Post.self, forPrimaryKey: postId) {
                    realm.delete(post)
                }
                
                guard realm.object(ofType: DeletedPost.self, forPrimaryKey: postId) == nil else { return }
                
                let deletedPost = DeletedPost()
                deletedPost.postId = postId
                realm.add(deletedPost)
                deletedPosts.insert(postId)
            }
        } catch {
            print("error removing post")
        }
    }
    
    func removeAllPosts() {
        do {
            try realm.write {
                let allPosts = realm.objects(Post.self)
                realm.delete(allPosts)
                
                deletedPosts = Set(posts.map { $0.id })
                for postId in deletedPosts {
                    guard realm.object(ofType: DeletedPost.self, forPrimaryKey: postId) == nil else { continue }
                    
                    let deletedPost = DeletedPost()
                    deletedPost.postId = postId
                    realm.add(deletedPost)
                }
            }
        } catch {
            print("Error removing all posts")
        }
    }
    
    private func loadFavorites() {
        let favoritePosts = realm.objects(FavoritePost.self)
        favorites = Set(favoritePosts.map { $0.postId })
    }
    
    func loadDeletedPosts() {
        do {
            try realm.write {
                let allDeletedPosts = realm.objects(DeletedPost.self)
                realm.delete(allDeletedPosts)
                
                let allPosts = realm.objects(Post.self)
                realm.delete(allPosts)
                
                self.deletedPosts.removeAll()
            }
        } catch {
            print("Error clearing deleted posts")
        }
        
        fetchPosts()
    }
    
    private func savePostsToRealm(posts: [Post]) {
        do {
            try realm.write {
                realm.add(posts, update: .modified)
            }
        } catch {
            print("Error saving posts to Realm")
        }
    }
}

//------------- UserDefaults----------
//import Foundation
//import Alamofire
//
//class PostsViewModel: ObservableObject {
//    @Published var posts: [Post] = []
//    @Published var errorMessage: String?
//    @Published var favorites: Set<Int> = []
//    @Published var deletedPosts: Set<Int> = []
//    @Published var isLoading: Bool = false
//    
//    private let favoritesKey = "favoritesKey"
//    private let deletedPostsKey = "deletedPostsKey"
//    
//    init() {
//        loadFavorites()
//        loadDeletedPosts()
//    }
//    
//    func fetchPosts() {
//        isLoading = true
//        ApiManager.shared.fetchPosts { result in
//            self.isLoading = false
//            switch result {
//            case .success(let posts):
//                self.posts = posts.filter { !self.deletedPosts.contains($0.id) }
//            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }
//    
//    func toggleFavorite(postId: Int) {
//        if favorites.contains(postId) {
//            favorites.remove(postId)
//        } else {
//            favorites.insert(postId)
//        }
//        saveFavorites()
//    }
//    
//    func removePost(postId: Int) {
//        posts.removeAll { $0.id == postId }
//        deletedPosts.insert(postId)
//        saveDeletedPosts()
//    }
//    
//    func removeAllPosts() {
//        posts.removeAll()
//        deletedPosts = Set(posts.map { $0.id })
//        saveDeletedPosts()
//    }
//    
//    private func saveFavorites() {
//        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
//    }
//    
//    private func loadFavorites() {
//        if let savedFavorites = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] {
//            favorites = Set(savedFavorites)
//        }
//    }
//    
//    private func saveDeletedPosts() {
//        UserDefaults.standard.set(Array(deletedPosts), forKey: deletedPostsKey)
//    }
//    
//    private func loadDeletedPosts() {
//        if let savedDeletedPosts = UserDefaults.standard.array(forKey: deletedPostsKey) as? [Int] {
//            deletedPosts = Set(savedDeletedPosts)
//        }
//    }
//}
