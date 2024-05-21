import Foundation
import SwiftUI

struct PostsView: View {
    @StateObject private var viewModel = PostsViewModel()
    @State private var selectedSegment = 0
    @State private var postToDelete: Post?
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Posts", selection: $selectedSegment) {
                    Text("All Posts").tag(0)
                    Text("Favorites").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if viewModel.isLoading {
                    ProgressView("Loading")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                } else {
                    List {
                        ForEach(filteredPosts) { post in
                            NavigationLink(destination: PostDetailView(post: post)) {
                                PostRowView(post: post, isFavorite: viewModel.favorites.contains(post.id))
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    viewModel.toggleFavorite(postId: post.id)
                                } label : {
                                    Label("Favorite", systemImage: "star.fill")
                                }
                                .tint(.yellow)
                            }
                            .swipeActions(edge: .leading) {
                                Button(role: .destructive) {
                                    postToDelete = post
                                    showAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                            
                        }
                    }
                    .navigationTitle("Posts")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                viewModel.removeAllPosts()
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                viewModel.fetchPosts()
                            } label: {
                                Image(systemName: "arrow.triangle.2.circlepath")
                            }
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Confirm Post Deletion"),
                            primaryButton: .destructive(Text("Delete")) {
                                if let post = postToDelete {
                                    viewModel.removePost(postId: post.id)
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchPosts()
        }
    }
    
    var filteredPosts: [Post] {
        if selectedSegment == 0 {
            return viewModel.posts
        } else {
            return viewModel.posts.filter { viewModel.favorites.contains($0.id) }
        }
    }
}

struct ContentView: View {
    var body: some View {
        PostsView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
