//
//  ComparisonView.swift
//  Movie
//
//  Created by KHJ on 2023/11/06.
//

import SwiftUI
import NukeUI

struct ComparisonView: View {
    @StateObject var comparisonViewModel: ComparisonViewModel
    init(movies: [Movie]) {
        _comparisonViewModel = StateObject(wrappedValue: ComparisonViewModel(movies: movies))
    }

    var body: some View {
        VStack {
            // Posters
            ZStack {
                if comparisonViewModel.hasSingleMovie {
                    Link(destination: comparisonViewModel.lastMovieHomepageURL) {
                        LazyImage(url: comparisonViewModel.lastMoviePosterURL) { state in
                            if let image = state.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                            } else if state.error != nil {
                            } else {
                                CustomProgressView(width: 250, height: 375)
                            }
                        }
                        .frame(width: 250, height: 375)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                    }
                } else {
                    ForEach(comparisonViewModel.movies) { movie in
                        NavigationLink {
                            DetailsView(movie: movie)
                        } label: {
                            StackedPosterView(movie: movie) { isSaved in
                                //  true 왼쪽으로 (save한 경우 )
                                withAnimation {
                                    if isSaved {
                                        comparisonViewModel.saveMoive()
                                    } else {
                                        comparisonViewModel.removeMovie()
                                    }
                                }
                            }
                            .stacked(at: comparisonViewModel.getIndex(of: movie), in: comparisonViewModel.movies.count)
                        }
                    
                    }
                }
            }
            Text(comparisonViewModel.currentMovieTitle)
                .font(.title2.bold())
                .padding()
            // Buttons
            HStack {
                actionButtons()
            }
            .font(.largeTitle)
            .disabled(comparisonViewModel.hasSingleMovie)

        }
        .padding(.top, 50)
        .navigationTitle("Now Playing")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension ComparisonView {
    @ViewBuilder func actionButtons() -> some View {
        Button {
            withAnimation {
                comparisonViewModel.saveMoive()
            }
            
        } label: {
            Label("", systemImage: "heart")
        }
        Button {
            withAnimation {
                comparisonViewModel.removeMovie()
            }
        } label: {
            Label("", systemImage: "x.circle")
        }
    }
}

struct StackedPosterView: View {
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
                CustomProgressView(width: 250, height: 375)
            }
        }
        .frame(width: 250, height: 375)
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

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x:0, y: offset * -5)
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