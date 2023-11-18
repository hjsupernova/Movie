//
//  MovieTapView.swift
//  Movie
//
//  Created by KHJ on 2023/09/30.
//

import SwiftUI

enum Views {
    case discover, library, search
}

struct MovieTabView: View {
    @State private var selectedTap: Views = .discover
    @StateObject var libraryViewModel = LibraryViewModel()
    @State private var showSignInView: Bool = false
    var body: some View {
        TabView(selection: $selectedTap) {
            DiscoverView()
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
        .environmentObject(libraryViewModel)
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
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
            .environmentObject(LibraryViewModel())
    }
}
