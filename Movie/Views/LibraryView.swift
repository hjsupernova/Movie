//
//  LibraryView.swift
//  Movie
//
//  Created by KHJ on 2023/10/02.
//

import SwiftUI

import NukeUI

struct LibraryView: View {
    @EnvironmentObject var libraryViewModel: LibraryViewModel
    @State private var isEditing = false
    let layout = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: layout) {
                    ForEach(libraryViewModel.favoriteMovies) { movie in
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
                                if isEditing {
                                    deleteButton(movie: movie)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .toolbar {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            }
            .animation(.default, value: isEditing)
        }
    }

    // MARK: - Computed views

    func deleteButton(movie: Movie) -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    Task {
                        await libraryViewModel.deleteFavoriteMovies(movie: movie)
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
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .preferredColorScheme(.dark)
            .environmentObject(LibraryViewModel())
            .tint(.white)
    }
}
