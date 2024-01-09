//
//  LibraryView.swift
//  Movie
//
//  Created by KHJ on 2023/10/02.
//

import SwiftUI

import NukeUI

struct LibraryView: View {
    @EnvironmentObject var favoriteMoivesManager: FavoriteMoviesManager
    @StateObject private var libraryViewModel = LibraryViewModel()

    let layout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            favoriteMoviesVGrid
            .navigationTitle("Library")
            .toolbar {
                editButton
            }
            .animation(.default, value: libraryViewModel.isEditing)

        }
    }

    // MARK: - Computed views
    
    private var favoriteMoviesVGrid: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: layout) {
                ForEach(favoriteMoivesManager.favoriteMovies) { movie in
                    NavigationLink {
                        DetailsView(movie: movie)
                    } label: {
                        ZStack {
                            LazyImage(url: movie.posterURL) { state in
                                if let image = state.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 140, height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                } else if state.error != nil {
                                } else {
                                    CustomProgressView(width: 140, height: 200)
                                }
                            }
                            if libraryViewModel.isEditing {
                                deleteButton(movie: movie)
                            }
                        }
                    }
                }
            }
        }
    }

    private func deleteButton(movie: Movie) -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    Task {
                        await favoriteMoivesManager.deleteFavoriteMovies(movie: movie)
                    }
                } label: {
                    Image(systemName: "x.circle")
                }
                .padding(5)
            }
            Spacer()
        }
        .frame(width: 140, height: 200)
    }

    private var editButton: some View {
        Button(libraryViewModel.isEditing ? "Done" : "Edit") {
            libraryViewModel.isEditing.toggle()
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .preferredColorScheme(.dark)
            .environmentObject(FavoriteMoviesManager())
            .tint(.white)
    }
}
