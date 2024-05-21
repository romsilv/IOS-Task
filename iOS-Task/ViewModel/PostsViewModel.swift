import Foundation
import Combine

class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var errorMessage: String?
    @Published var favorites: Set<Int> = []
    @Published var deletedPosts: Set<Int> = []
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private let favoritesKey = "favoritesKey"
    private let deletedPostsKey = "deletedPostsKey"
    
    init() {
        loadFavorites()
        loadDeletedPosts()
    }
    
    func fetchPosts() {
        isLoading = true
        ApiManager.shared.fetchPosts()
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { posts in
                self.posts = posts.filter { !self.deletedPosts.contains($0.id) }
            })
            .store(in: &cancellables)
    }
    
    func toggleFavorite(postId: Int) {
        if favorites.contains(postId) {
            favorites.remove(postId)
        } else {
            favorites.insert(postId)
        }
        saveFavorites()
    }
    
    func removePost(postId: Int) {
        posts.removeAll { $0.id == postId }
        deletedPosts.insert(postId)
        saveDeletedPosts()
    }
    
    func removeAllPosts() {
        posts.removeAll()
        deletedPosts = Set(posts.map { $0.id })
        saveDeletedPosts()
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] {
            favorites = Set(savedFavorites)
        }
    }
    
    private func saveDeletedPosts() {
        UserDefaults.standard.set(Array(deletedPosts), forKey: deletedPostsKey)
    }
    
    private func loadDeletedPosts() {
        if let savedDeletedPosts = UserDefaults.standard.array(forKey: deletedPostsKey) as? [Int] {
            deletedPosts = Set(savedDeletedPosts)
        }
    }
}

