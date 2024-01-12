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
            titleText
            emailTextField
            compareButton
            Spacer()
        }
        .padding()
        .navigationTitle("Taste Match")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture {
            isEmailFocused = false
        }
        .sheet(isPresented: $tasteMatchViewModel.showingSheet, content: {
            TasteMatchDetailView(score: tasteMatchViewModel.score, movie: tasteMatchViewModel.matchedMovies?.first)
        })
        .alert(tasteMatchViewModel.alertTitle, isPresented: $tasteMatchViewModel.showAlert) {
        } message: {
            Text("Error: \(tasteMatchViewModel.alertMsg)")
        }
    }

    // MARK: - Computed Views

    @ViewBuilder
    private var userImage: some View {
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

    private var titleText: some View {
        Text("Compare your movie taste with a friend")
            .font(.largeTitle.bold())
            .multilineTextAlignment(.center)
            .padding(.bottom, 24)
    }

    private var emailTextField: some View {
        TextField("Enter your friend's email address", text: $tasteMatchViewModel.email)
            .onChange(of: tasteMatchViewModel.email) { email in
                tasteMatchViewModel.isValidEmailAddr(string: email)
            }
            .padding(10)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(.bottom, 12)
            .focused($isEmailFocused)
            .keyboardType(.emailAddress)
    }

    private var compareButton: some View {
        Button("Compare") {
            Task {
                await tasteMatchViewModel.compareMovieTaste(friendEmail: tasteMatchViewModel.email)
            }
        }
        .foregroundStyle(.black)
        .buttonStyle(.borderedProminent)
        .disabled(!tasteMatchViewModel.isVaildEmail)
    }
}

#Preview {
    TasteMatchView()
        .preferredColorScheme(.dark)
}
