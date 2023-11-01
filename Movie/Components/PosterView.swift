//
//  PosterView.swift
//  Movie
//
//  Created by KHJ on 2023/10/02.
//

import SwiftUI
import NukeUI

struct PosterView: View {
    
    let movie: Movie
    init(movie: Movie) {
        self.movie = movie
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LazyImage(url: movie.posterURL) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if state.error != nil {
                    Text("Error")
                } else {
                    CustomProgressView()
                }
            }
            .reflection()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(movie.title)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                HStack() {
                    Image("tmdbLogo")
                        .resizable()
                        .frame(width: 20, height: 8)
                    Text(String(format: "%.1f", movie.vote_average))
                        .font(.caption2)
                        .fontWeight(.semibold)
                        
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(4)
            .padding(.leading, 4)
            .foregroundStyle(.white)
        }
        .frame(width: 140, height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        



    }
}



private struct GroundReflectionViewModifier: ViewModifier {
    let offsetY: CGFloat
    func body(content: Content) -> some View {
        content
            .background(
                content
                    .mask(
                        LinearGradient(
                            gradient: Gradient(stops: [.init(color: .white, location: 0.0), .init(color: .clear, location: 0.6)]),
                            startPoint: .bottom,
                            endPoint: .top)
                    )
                    .scaleEffect(x: 1.0, y: -1.0, anchor: .bottom)
                    .opacity(0.3)
                    .blur(radius: 2)
                    .offset(y: offsetY)
            )
    }
}

extension View {
    func reflection(offsetY: CGFloat = 0) -> some View {
        modifier(GroundReflectionViewModifier(offsetY: offsetY))
    }
}




struct PosterView_Previews: PreviewProvider {
    static var previews: some View {
        PosterView(movie: .preview)
//            .background(.black)
    }
}
