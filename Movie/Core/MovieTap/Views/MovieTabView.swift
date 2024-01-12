//
//  MovieTapView.swift
//  Movie
//
//  Created by KHJ on 2023/09/30.
//

import SwiftUI

import NukeUI

enum Views {
    case discover, library, search
}

struct MovieTabView: View {
    @StateObject var movieTabViewModel = MovieTabViewModel()
    
    var body: some View {
        TabView(selection: $movieTabViewModel.selectedTap) {
            DiscoverView(showSignInView: $movieTabViewModel.showSignInView)
                .tabItem {
                    Image(systemName: "house")
                }
                .onAppear { movieTabViewModel.selectedTap = .discover }
                .tag(Views.discover)
            LibraryView()
                .tabItem {
                    Image(systemName: "folder")
                }
                .onAppear { movieTabViewModel.selectedTap = .library }
                .tag(Views.library)
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .onAppear { movieTabViewModel.selectedTap = .search }
                .tag(Views.search)
        }
        .task {
            await movieTabViewModel.loadCurrentUser()
        }
        .fullScreenCover(isPresented: $movieTabViewModel.showSignInView, content: {
            NavigationStack {
                AuthenticationView(showSignInView: $movieTabViewModel.showSignInView)
            }
        })
    }
}

struct MovieTapView_Previews: PreviewProvider {
    static var previews: some View {
        MovieTabView()
    }
}
