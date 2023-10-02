//
//  MovieTapView.swift
//  Movie
//
//  Created by KHJ on 2023/09/30.
//

import SwiftUI

struct MovieTabView: View {
    @State private var selectedTap = 0
    @StateObject var movieDiscoverViewModel = MovieDiscoverViewModel()
    @StateObject var movieDetailsViewModel = MovieDetailsViewModel()
    var body: some View {
        TabView(selection: $selectedTap) {
            DiscoverView(viewModel: movieDiscoverViewModel, movieDetailsViewModel: movieDetailsViewModel)
                .tabItem {
                    Image(systemName: "house")
                }
                .onAppear { selectedTap = 0 }
                .tag(0)
            
            LibraryView(detailsViewModel: movieDetailsViewModel)
                .tabItem {
                    Image(systemName: "folder")
                }
                .onAppear { selectedTap = 1 }
                .tag(1)
            
            SearchView(viewModel: movieDiscoverViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .onAppear { selectedTap = 2 }
                .tag(2)
        }
        .tint(.white)
        
    }
}

struct MovieTapView_Previews: PreviewProvider {
    static var previews: some View {
        MovieTabView()
    }
}
