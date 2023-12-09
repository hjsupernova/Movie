//
//  TasteMatchView.swift
//  Movie
//
//  Created by KHJ on 2023/11/20.
//

import OSLog
import SwiftUI

import NukeUI

struct TasteMatchView: View {
    @StateObject var tasteMatchViewModel = TasteMatchViewModel()
    @FocusState private var isEmailFocused: Bool
    var body: some View {
        VStack(spacing: 0) {
            userImage
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
                .focused($isEmailFocused)
                .keyboardType(.emailAddress)
            Button("Compare") {
                Task {
                    #warning("뷰모델로 빼기,, 인덱스 접근 안하기!!")
                    do {
                        // 공통 영화 찾기
                        try await tasteMatchViewModel.findMatchedMovies(friendEmail: tasteMatchViewModel.email)
                        // 공통 영화 기반 점수 계산
                        tasteMatchViewModel.calculateTasteMatchPercentage()
                    } catch {
                        Logger.firestore.error("Failed to fetch fmovies.")
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

        .onTapGesture {
            isEmailFocused = false
        }
    }

    // MARK: - Computed Views

    @ViewBuilder
    var userImage: some View {
        if let photoURL = tasteMatchViewModel.user?.photoUrl {
            LazyImage(url: URL(string: photoURL)) { state in
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
                    ZStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .offset(x: 60)
                            .foregroundStyle(.gray)
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .offset(x: -60)
                    }
                } else {
                    ProgressView()
                }
            }
            .padding(.bottom, 24)
        } else {
            ZStack {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .offset(x: 60)
                    .foregroundStyle(.gray)
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .offset(x: -60)
                    .foregroundStyle(Color(UIColor.systemGray2))
            }
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    TasteMatchView()
        //        .tint(.white)
        .preferredColorScheme(.dark)
}
