//
//  DetailsView.swift
//  Movie
//
//  Created by KHJ on 2023/09/12.
//

import SwiftUI
import NukeUI



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
                //BackDrop
                VStack  {
                    LazyImage(url: movie.backdropURL) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else if phase.error != nil {
                            Text("Error")
                        } else {
                            ProgressView()
                        }
                    }
                    .opacity(0.5)
                    Spacer()
                }
                // 전부 다 들은 VStack
                VStack(alignment:.leading) {
                    //title
                    Text(movie.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                        .bold()
                        .padding(.top, 80)
                    // 점수 장르 년도
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image("tmdbLogo")
                                    .resizable()
                                    .frame(width: 20, height: 8)
                                Text(String(format: "%.1f", movie.vote_average))
                                    .bold()
                            }
                            HStack {
                                Text(movie.original_language.uppercased())
                                    .padding(2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 2)
                                            .strokeBorder(.gray, lineWidth: 1)
                                    )
                                Text("\(movie.genres!)")
                            }
                            Text(movie.release_date.split(separator: "-").first ?? "N/A")
                        }
                        
                    }
                    .padding(.bottom, 16)
                    // 오버뷰
                    Text(movie.overview)
                        .lineLimit(lineLimit)
                        .onTapGesture {
                            withAnimation {
                                lineLimit = 10
                            }
                        }
                    // Buttons
                    HStack {
                        Spacer()
                        // 라이브러리 추가 + 삭제 버튼
                        // extension으로 이나 view로 빼기
                        // 버튼 리팩토링 하기
                        if libraryViewModel.isFavorite(movie: movie) {
                            Button {
                                withAnimation {
                                    libraryViewModel.deleteFavoriteMovies(movie: movie)
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
                                withAnimation {
                                    libraryViewModel.addFavoriteMovies(movie: movie)
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
                        Button() {
                            
                        } label: {
                            VStack {
                                Image(systemName: "play.circle")
                                Text("Trailer")
                                    .font(.headline)
                                    .bold()
                            }
                        }
                        Spacer()
                        Button() {
                            
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
                    .foregroundColor(.white)
                    .padding(.vertical)
                    
                    // Cast View
                    Text("Cast")
                        .font(.title2.bold())
                    ScrollView(.horizontal,showsIndicators: false) {
                        LazyHStack {
                            ForEach(detailsViewModel.cast) { castMember in
                                CastView(castMember: castMember)
                            }
                        }
                    }
                    .frame(height: 150)
                    .padding(.bottom, 20)
                    //Recommendations View ( when existed )
                    if !detailsViewModel.recommendations.isEmpty {
                        Text("Recommendations")
                            .font(.title2.bold())
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(detailsViewModel.recommendations) { movie in
                                    NavigationLink {
                                        DetailsView(movie: movie, detailsViewModel: detailsViewModel)
                                    } label: {
                                        PosterView(movie: Movie(adult: false, backdrop_path: "", id: movie.id, original_language: "", overview: "", poster_path: movie.poster_path ?? "", release_date: "", title: movie.title, vote_average: movie.vote_average, genre_ids: []))
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 100)
                    }
                    
                }
                .padding()
            }
        }
        .ignoresSafeArea()
        .task {
            guard !hasAppeared else { return }
            hasAppeared = true
            await detailsViewModel.loadDetailsElements(for: movie.id)
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
    }
}


