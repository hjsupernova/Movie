//
//  GroundReflectionViewModifier.swift
//  Movie
//
//  Created by KHJ on 2023/11/04.
//

import Foundation
import SwiftUI

struct GroundReflectionViewModifier: ViewModifier {
    let offsetY: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                content
                    .mask(
                        LinearGradient(
                            gradient: Gradient(stops: [.init(color: .white, location: 0.0),
                                                       .init(color: .clear, location: 0.6)]),
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
    func refelction(offsetY: CGFloat = 1) -> some View {
        modifier(GroundReflectionViewModifier(offsetY: offsetY))
    }
}
