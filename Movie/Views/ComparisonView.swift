//
//  ComparisonView.swift
//  Movie
//
//  Created by KHJ on 2023/11/06.
//

import SwiftUI
import NukeUI

struct ComparisonView: View {
    @State var movies: [Movie]
    @State private var showSheet = false
    @State private var selectedMovie: Movie?
    var body: some View {
        // Posters
        ZStack {
            if movies.count == 1 {
                Link(destination: movies[0].homepageURL) {
                    LazyImage(url: movies[0].posterURL) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else if state.error != nil {
                        } else {
                            CustomProgressView(width: 140, height: 240)
                        }
                    }
                    .frame(width: 140, height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                }
            } else
            {
                ForEach(movies) { movie in
                    NavigationLink {
                        DetailsView(movie: movie)
                    } label: {
                        StackedPosterView(movie: movie) { isSaved in
                            //  true 왼쪽으로 (save한 경우 )
                            if isSaved {
                                withAnimation {
                                    let savedMovie = movies.remove(at: getIndex(of: movie))
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        movies.insert(savedMovie, at: 0)
                                    }
                                }
                            } else {
                                withAnimation { _ = movies.remove(at: getIndex(of: movie))}
                            }
                        }
                        .stacked(at: getIndex(of: movie), in: movies.count)
                    }
                }
            }
        }
        // Buttons
        HStack {
            Button {
                save(movie: movies[movies.count - 1] )
            } label: {
                Label("", systemImage: "heart")
            }
            Button {
                remove()
            } label: {
                Label("", systemImage: "x.circle")
            }
        }
        .font(.largeTitle)
        .disabled(movies.count == 1)
    }
    
    func getIndex(of movie: Movie) -> Int {
        for i in 0...movies.count {
            if movies[i].id == movie.id {
                return i
            }
        }
        return -1
    }
    func save(movie: Movie) {
        let savedMovie = movies.remove(at: getIndex(of: movie))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            movies.insert(savedMovie, at: 0)
        }
    }
    func remove() {
        withAnimation { _ = movies.remove(at: getIndex(of: movies[movies.count - 1]))}
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x:0, y: offset * -5)
    }
}

struct StackedPosterView: View  {
    let movie: Movie
    var removal: ( (_ correct: Bool) -> Void)? = nil
    @State private var offset = CGSize.zero
    
    var body: some View {
        LazyImage(url: movie.posterURL) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFill()
            } else if state.error != nil {
            } else {
                CustomProgressView(width: 140, height: 240)
            }
        }
        .frame(width: 140, height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .rotationEffect(.degrees(Double(offset.width / 5 )))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    offset = gesture.translation
                })
                .onEnded({ _ in
                    // 일정 스와이프 값을 넘은 경우
                    if abs(offset.width) > 100 {
                        var isSaved: Bool
                        // 오른쪽으로 스와이프
                        if offset.width > 0  {
                            isSaved = false
                            print("swipe to right to delete")
                            // 왼쪽으로 스와이프
                        } else {
                            isSaved = true
                            print("swipe to left to save")
                        }
                        removal?(isSaved)
                        
                    } else {
                        offset = .zero
                    }
                })
        )
        .animation(.spring(), value: offset)
        
    }
}

#Preview {
    ComparisonView(
        movies: (
            [
                Movie.preview,
                Movie.preview2,
                Movie.preview3
            ]
        )
    )
    .preferredColorScheme(.dark)
    .tint(.white)
}
