//
//  SearchView.swift
//  Movie
//
//  Created by KHJ on 2023/09/28.
//

import SwiftUI
import NukeUI

struct SearchView: View {
    @StateObject var searchViewModel = SearchViewModel()
    let layout = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationView {
            // Searched Movies
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: layout) {
                    ForEach(searchViewModel.searchedMovies) { movie in
                        NavigationLink {
                            DetailsView(movie: movie)
                        } label: {
                            PosterView(movie: movie)
                        }
                        .onAppear {
                            if movie == searchViewModel.searchedMovies.last {
                                Task {
                                    await searchViewModel.loadMore()
                                }
                            }
                        }
                        
                    }
                }
            }
            .searchable(
                text: $searchViewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Shows, Movies and More"
            )
            .onSubmit(of: .search) {
                Task {
                    await searchViewModel.searchMovies()
                }
            }
            .navigationTitle("Search")
            .alert(isPresented: $searchViewModel.showAlert, content: {
                Alert(title: Text("Error"), message: Text(searchViewModel.errorMsg))
            })
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchViewModel: SearchViewModel())
            .preferredColorScheme(.dark)
            .tint(.white)
    }
}
