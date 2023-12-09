//
//  DetailsView.swift
//  Movie
//
//  Created by KHJ on 2023/09/12.
//

import NukeUI
import SwiftUI

struct DetailsView: View {
    var movie: Movie
    @StateObject var detailsViewModel = DetailsViewModel()
    @EnvironmentObject var libraryViewModel: LibraryViewModel
    @State private var lineLimit = 3
    // TabView에서 왔다갔다 할 때도 이게 network ( .task) 발생 방지.
    @State private var hasAppeared = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                // BackDrop
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
                // Title ~ Recommendations
                VStack(alignment: .leading) {
                    // Information
                    movieInformation(movie: movie)
                    // Buttons
                    actionButtons(moive: movie)
                    // Cast View
                    CastListView(cast: detailsViewModel.cast)
                    // Recommendations View ( when existed )
                    if !detailsViewModel.recommendations.isEmpty {
                        PosterListView(title: "Recommendations", movies: detailsViewModel.recommendations)
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            guard !hasAppeared else { return }
            hasAppeared = true
            await detailsViewModel.loadDetailsElements(for: movie.id)
        }
        .alert(isPresented: $detailsViewModel.showAlert, content: {
            Alert(title: Text("Error"), message: Text(detailsViewModel.errorMsg))
        })
    }

    // MARK: - Computed views

    @ViewBuilder
    func actionButtons(moive: Movie) -> some View {
        
        HStack {
            Spacer()
            // Save
            if libraryViewModel.isFavorite(movie: movie) {
                Button {
                    Task {
                        await libraryViewModel.deleteFavoriteMovies(movie: movie)
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
                        await libraryViewModel.addFavoriteMovies(movie: movie)
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
                #warning("Button!!!")
                let urlShare = movie.homepageURL
                let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
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

    @ViewBuilder
    func movieInformation(movie: Movie) -> some View {
        // title
        Text(movie.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title.bold())
            .padding(.top, 80)
        // Score, Genre, Release date
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
                    Text(movie.original_language.uppercased())
                        .padding(2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .strokeBorder(.gray, lineWidth: 1)
                        )
                    #warning("느낌표")
                    Text("\(movie.genres!)")
                }
                Text(movie.release_date.split(separator: "-").first ?? "N/A")
            }
        }
        .padding(.bottom, 16)
        // Overview
        Text(movie.overview)
            .lineLimit(lineLimit)
            .onTapGesture {
                withAnimation {
                    lineLimit = 10
                }
            }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailsView(movie: .preview, detailsViewModel: DetailsViewModel())
                .preferredColorScheme(.dark)
                .environmentObject(LibraryViewModel())
        }
        .tint(.white)
    }
}
