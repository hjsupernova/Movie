//
//  AuthenticationView.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding var showSignInView: Bool
    var body: some View {
        VStack {
            VStack {
                Text("🍿")
                Text("Login to a reel world of movie memories")
            }
            .multilineTextAlignment(.center)
            .font(.largeTitle.bold())
            
            VStack {
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    Text("Sign Up With Email")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                }
                Button("Sign in with Google") {
                    
                }
            }
            .padding(.vertical)
        }
        .padding()
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
        .preferredColorScheme(.dark)
}
