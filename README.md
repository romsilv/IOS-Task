# iOS Posts App

## Description

This iOS application uses SwiftUI and the MVVM architecture to list messages retrieved from the JSONPlaceholder API. Users can view the details of each message, mark messages as favorites, and perform other operations.

## Features

1. **List Posts**: The app loads and displays all posts from the JSONPlaceholder API.
2. **Post Details**: Tapping on a post navigates the user to a detail view showing the full information of the post.
3. **Favorites**: Users can mark posts as favorites. Favorite posts are displayed with a star icon and always appear at the top of the list.
4. **Delete Posts**: Users can delete individual posts or all posts at once.
5. **Persistence**: Favorite and deleted posts are saved using `UserDefaults` to maintain data persistence between sessions.
6. **Segmented Control**: Users can toggle between viewing all posts and only favorites.
7. **Loading Indicator**: A spinner is shown while posts are loading.
8. **Delete Confirmation**: A warning button asks for confirmation before deleting a post.

## Requirements

- iOS 14.0 or later
- Xcode 12 or later

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture.

- **Model**: Defines the data structures and handles persistence logic with `UserDefaults`.
- **View**: The views are built using SwiftUI and represent the user interface.
- **ViewModel**: It manages business logic, interacts with the API, and updates the views as needed.

## API Manager

The `APIManager` class handles all network requests using Combine.
