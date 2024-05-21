import Foundation
import SwiftUI
import Combine

struct PostDetailView: View {
    let post: Post
    @StateObject private var viewModel = PostDetailViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Description")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(post.body)
              .font(.body)
              .fontWeight(.light)
              .lineLimit(4)
              .truncationMode(.tail)
            
            Text("User: \(viewModel.user?.name ?? "Nil Name")")
                .font(.subheadline)
            
            Text("Username: \(viewModel.user?.username ?? "Nil UserName")")
                .font(.subheadline)
            
            Text("Email: \(viewModel.user?.email ?? "Nil Email.")")
                .font(.subheadline)
            
            Divider()
            
            Text("Comments")
                .font(.title2)
                .fontWeight(.bold)
            
            List(viewModel.comments) { comment in
                VStack(alignment: .leading) {
                    Text(comment.name)
                        .font(.headline)
                    Text(comment.body)
                        .font(.body)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Post Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchUser(userId: post.userId)
            viewModel.fetchComments(postId: post.id)
        }
    }
}

class PostDetailViewModel: ObservableObject {
    @Published var user: User?
    @Published var comments: [Comment] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUser(userId: Int) {
        ApiManager.shared.fetchUser(userId: userId)
            .sink(receiveCompletion: { _ in }, receiveValue: { user in
                self.user = user
            })
            .store(in: &cancellables)
    }
    
    func fetchComments(postId: Int) {
        ApiManager.shared.fetchComments(postId: postId)
            .sink(receiveCompletion: { _ in }, receiveValue: { comments in
                self.comments = comments
            })
            .store(in: &cancellables)
    }
}
