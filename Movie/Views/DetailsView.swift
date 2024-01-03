//
//  DetailsView.swift
//  Movie
//
//  Created by KHJ on 2023/09/12.
//

import SwiftUI

import NukeUI

struct DetailsView: View {
    @StateObject var detailsViewModel = DetailsViewModel()
    @EnvironmentObject var favoriteMoviesManager: FavoriteMoviesManager

    var movie: Movie

    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                backdropSection
                VStack(alignment: .leading) {
                    informationSection
                    actionButtons
                    CastListView(cast: detailsViewModel.cast)
                    recommendations
                }
                .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await detailsViewModel.fetchDetailsElements(for: movie.id)
        }
        .alert(isPresented: $detailsViewModel.showAlert, content: {
            Alert(title: Text("Error"), message: Text(detailsViewModel.errorMsg))
        })
    }

    // MARK: - Computed views

    private var backdropSection: some View {
        VStack {
            LazyImage(url: movie.backdropURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                } else {
                    ProgressView()
                }
            }
            .opacity(0.5)
            Spacer()
        }
    }

    private var actionButtons: some View {
        HStack {
            Spacer()
            // Save
            if favoriteMoviesManager.isFavorite(movie: movie) {
                Button {
                    Task {
                        await favoriteMoviesManager.deleteFavoriteMovies(movie: movie)
                    }
                } label: {
                    VStack {
                        Image(systemName: "x.circle")
                        Text("Delete it")
                            .font(.headline)
                            .bold()
                    }
                }
            } else {
                Button {
                    Task {
                        await favoriteMoviesManager.addFavoriteMovies(movie: movie)
                    }

                } label: {
                    VStack {
                        Image(systemName: "plus.circle")
                        Text("Save it")
                            .font(.headline)
                            .bold()
                    }
                }
            }
            Spacer()
            // Trailer
            Link(destination: movie.homepageURL) {
                VStack {
                    Image(systemName: "play.circle")
                    Text("Trailer")
                        .font(.headline)
                        .bold()
                }
            }
            Spacer()
            // Share
            Button {
                detailsViewModel.shareMovie(homepageURL: movie.homepageURL)
            } label: {
                VStack {
                    Image(systemName: "square.and.arrow.up.circle")
                    Text("Share")
                        .font(.headline)
                        .bold()
                }
            }
            Spacer()
        }
        .font(.system(size: 50))
        .fontWeight(.light)
        .padding(.vertical)
    }


    private var informationSection: some View {
        Group {
            movieTitle
            scoreGenreAndReleaseDate
            overviewSection
        }
    }

    private var movieTitle: some View  {
        Text(movie.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title.bold())
            .padding(.top, 80)
    }

    private var scoreGenreAndReleaseDate: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image("tmdbLogo")
                        .resizable()
                        .frame(width: 20, height: 8)
                    Text(movie.formattedVoteAverage)
                        .bold()
                }
                HStack {
                    Text(movie.originalLanguage.uppercased())
                        .padding(2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .strokeBorder(.gray, lineWidth: 1)
                        )
                    Text(movie.genres)
                }
                Text(movie.releaseDate.split(separator: "-").first ?? "N/A")
            }
        }
        .padding(.bottom, 16)
    }

    private var overviewSection: some View {
        Text(movie.overview)
            .lineLimit(detailsViewModel.lineLimit)
            .onTapGesture {
                withAnimation {
                    detailsViewModel.increaseLineLimit()
                }
            }
    }

    @ViewBuilder
    private var recommendations: some View {
        // Recommendations View ( when existed )
        if !detailsViewModel.recommendations.isEmpty {
            PosterListView(title: "Recommendations", movies: detailsViewModel.recommendations)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailsView(detailsViewModel: DetailsViewModel(), movie: .preview)
                .preferredColorScheme(.dark)
                .environmentObject(FavoriteMoviesManager())
        }
        .tint(.white)
    }
}
