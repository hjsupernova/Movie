//
//  TasteMatchView.swift
//  Movie
//
//  Created by KHJ on 2023/11/20.
//

import NukeUI
import SwiftUI

struct TasteMatchView: View {
    @StateObject var tasteMatchViewModel = TasteMatchViewModel()
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                if let photoURL = tasteMatchViewModel.user?.photoUrl {
                    userImage(url: photoURL)
                }
                Text("Compare your movie taste with a friend")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
                
                TextField("Enter your friend's email address", text: $tasteMatchViewModel.email)
                    .onChange(of: tasteMatchViewModel.email, perform: { email in
                        tasteMatchViewModel.isValidEmailAddr(string: email)
                    })
                    .padding(10)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.bottom, 12)
                Button("Compare") {
                    Task {
                        do {
                            // 공통 영화 찾기
                            try await tasteMatchViewModel.findMatchedMovies(friendEmail: tasteMatchViewModel.email)
                            // 공통 영화 기반 점수 계산
                            tasteMatchViewModel.calculateTasteMatchPercentage()
                            
                            tasteMatchViewModel.email = ""
                        } catch {
                            print("Failed to fetch fmovies.")
                        }
                    }
                }
                .foregroundStyle(.black)
                .buttonStyle(.borderedProminent)
                .disabled(!tasteMatchViewModel.isVaildEmail)
                Spacer()
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .sheet(isPresented: $tasteMatchViewModel.showingSheet, content: {
                TasteMatchDetailView(score: tasteMatchViewModel.score, movie: tasteMatchViewModel.matchedMovies?[0])
            })
            .padding()
            .navigationTitle("Taste Match")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    // MARK: - Computed Views
    func userImage(url: String) -> some View {
        LazyImage(url: URL(string: url)) { state in
            if let image = state.image {
                ZStack {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .offset(x: 60)
                        .foregroundStyle(.gray)
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .offset(x: -60)
                }
            } else if state.error != nil {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            } else {
                ProgressView()
            }
        }
        .padding(.bottom, 24)
    }
}

#Preview {
    TasteMatchView()
        .tint(.white)
}
