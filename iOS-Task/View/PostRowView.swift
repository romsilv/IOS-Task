import Foundation
import SwiftUI

struct PostRowView: View {
    let post: Post
    let isFavorite: Bool
    
    var body: some View {
        HStack {
            if isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            Text(post.title)
                .lineLimit(nil)
        }
    }
}
