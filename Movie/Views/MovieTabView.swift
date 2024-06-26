//
//  MovieTapView.swift
//  Movie
//
//  Created by KHJ on 2023/09/30.
//

import SwiftUI

import NukeUI

@MainActor
final class MovieTabViewModel: ObservableObject {
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
}
enum Views {
    case discover, library, search
}

struct MovieTabView: View {
    @StateObject var movieTabViewModel = MovieTabViewModel()
    @State private var selectedTap: Views = .discover
    @State private var showSignInView: Bool = false
    
    var body: some View {
        TabView(selection: $selectedTap) {
            DiscoverView(showSignInView: $showSignInView)
                .tabItem {
                    Image(systemName: "house")
                }
                .onAppear { selectedTap = .discover }
                .tag(Views.discover)
            LibraryView()
                .tabItem {
                    Image(systemName: "folder")
                }
                .onAppear { selectedTap = .library }
                .tag(Views.library)
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .onAppear { selectedTap = .search }
                .tag(Views.search)
        }
        .tint(.white)
        .task {
            do {
                try await movieTabViewModel.loadCurrentUser()
            } catch {
                self.showSignInView = true
            }
        }
        .fullScreenCover(isPresented: $showSignInView, content: {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        })
    }
}

struct MovieTapView_Previews: PreviewProvider {
    static var previews: some View {
        MovieTabView()
    }
}
