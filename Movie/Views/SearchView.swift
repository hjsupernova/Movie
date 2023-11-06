//
//  SearchView.swift
//  Movie
//
//  Created by KHJ on 2023/09/28.
//

import SwiftUI
import NukeUI

struct SearchView: View {
    @StateObject var serachViewModel = SearchViewModel()
    let layout = [
        GridItem(.adaptive(minimum: 300, maximum: 500)),
        GridItem(.adaptive(minimum: 300, maximum: 500))
        
    ]
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // NavBar
                    HStack {
                        Text("Search")
                            .font(.largeTitle.bold())
                        Spacer()
                        
                        NavigationLink {
                            Text("Person View")
                        } label: {
                            Image(systemName: "person.crop.circle")
                                .font(.largeTitle)
                        }
                        
                    }
                    SearchBar(searchText: $searchText)
                        .onSubmit {
                            Task {
                                await serachViewModel.searchMovies(text: searchText)
                            }
                        }
                    // Searched Movies
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: layout) {
                            ForEach(serachViewModel.searchedMovies) { movie in
                                NavigationLink {
                                    DetailsView(movie: movie)
                                } label: {
                                    PosterView(movie: movie)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .padding()
            }
        }
    }
}

// MARK: - Subviews
struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            TextField("\(Image(systemName:"magnifyingglass")) Shows, Movies and More", text: $searchText)
                .padding(10)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(serachViewModel: SearchViewModel())
            .preferredColorScheme(.dark)
            .tint(.white)

    }
}
