import SwiftUI

struct PostsView: View {
    @StateObject private var viewModel = PostsViewModel()
    @State private var selectedSegment = 0
    @State private var postToDelete: Post?
    @State private var showAlert = false
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Posts".localized, selection: $selectedSegment) {
                    Text("All Posts".localized).tag(0)
                    Text("Favorites".localized).tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading".localized)
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                    Spacer()
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
                    .navigationTitle("Posts".localized)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                viewModel.loadDeletedPosts()
                            } label: {
                                Image(systemName: "arrow.triangle.2.circlepath")
                            }
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Confirm Post Deletion".localized),
                            primaryButton: .destructive(Text("Delete".localized)) {
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
        .onReceive(NotificationCenter.default.publisher(for: .languageChanged)) { _ in
            selectedSegment = selectedSegment
        }
    }
    
    var filteredPosts: [Post] {
        if selectedSegment == 0 {
            return viewModel.posts
        } else {
            return viewModel.posts.filter { viewModel.favorites.contains($0.id) }
        }
    }
    
    private func changeLanguage(to languageCode: String) {
        languageManager.setLanguage(languageCode: languageCode)
    }
}

struct ContentView: View {
    var body: some View {
        PostsView()
            .environmentObject(LanguageManager.shared)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LanguageManager.shared)
    }
}
