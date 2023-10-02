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
    
    let cast: Credits.Cast
    
    var body: some View {
    
        VStack {
            LazyImage(url: cast.photoUrl) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(.white,   lineWidth: 1)
                        )
                } else if phase.error != nil {
                    
                    Image(systemName: "person")
                        .font(.system(size: 65))
                        .frame(width: 100, height: 120)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(.white, lineWidth: 1))
                    
                    
                } else  {
                    ProgressView()
                        .frame(width: 100, height: 120)
                    
                }
                
            }
            Text(cast.name)
                .lineLimit(1)
                .frame(width: 100)
            
            
        }
        
        
    }
}

struct Cast_Previews: PreviewProvider {
    static var previews: some View {
        CastView(cast: .preview)
    }
}
