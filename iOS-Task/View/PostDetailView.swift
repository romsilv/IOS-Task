import Foundation
import SwiftUI

struct PostDetailView: View {
    let post: Post
    @StateObject private var viewModel = PostDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Description")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(post.body)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 10)
                
                Divider()
                
                Group {
                    Text("User Information")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text("Name:")
                            .fontWeight(.bold)
                        Text(viewModel.user?.name ?? "Nil Name")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Username:")
                            .fontWeight(.bold)
                        Text(viewModel.user?.username ?? "Nil Username")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Email:")
                            .fontWeight(.bold)
                        Text(viewModel.user?.email ?? "Nil Email")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                
                Divider()
                
                Text("Comments")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                ForEach(viewModel.comments) { comment in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(comment.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(comment.body)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground))
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
    
    func fetchUser(userId: Int) {
        ApiManager.shared.fetchUser(userId: userId) { result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.user = user
                }
            case .failure(let error):
                print("Error fetching user: \(error)")
            }
        }
    }
    
    func fetchComments(postId: Int) {
        ApiManager.shared.fetchComments(postId: postId) { result in
            switch result {
            case .success(let comments):
                DispatchQueue.main.async {
                    self.comments = comments
                }
            case .failure(let error):
                print("Error fetching comments: \(error)")
            }
        }
    }
}
