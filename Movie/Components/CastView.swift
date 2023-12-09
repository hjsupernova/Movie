//
//  CastView.swift
//  Movie
//
//  Created by KHJ on 2023/09/14.
//

import Foundation
import SwiftUI

import NukeUI

struct CastView: View {
    let castMember: CastMember
    var body: some View {
        VStack {
            LazyImage(url: castMember.photoUrl) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(Color(UIColor.systemGray4), lineWidth: 1)
                        )
                } else if phase.error != nil {
                    Image(systemName: "person")
                        .font(.system(size: 65))
                        .frame(width: 100, height: 120)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(Color(UIColor.systemGray4), lineWidth: 1))
                } else {
                    CustomProgressView(width: 100, height: 120)
                }
            }
            Text(castMember.name)
                .lineLimit(1)
                .frame(width: 100)
        }
    }
}

struct CastListView: View {
    let cast: [CastMember]
    var body: some View {
        Text("Cast")
            .font(.title2.bold())
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(cast) { castMember in
                    CastView(castMember: castMember)
                }
            }
        }
        .frame(height: 150)
        .padding(.bottom, 20)
    }
}

struct Cast_Previews: PreviewProvider {
    static var previews: some View {
        CastView(castMember: .preview)
            .preferredColorScheme(.dark)
    }
}
