//
//  SettingsView.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSingInView: Bool
    var body: some View {
        List {
            Button("Sign out") {
                do {
                    try viewModel.signOut()
                    showSingInView = true
                } catch {
                    // TODO: Combine으로 에러 처리 하기 + do catch 문은 ViewModel에서 처리
                    #warning("PassthroughSubject, onReceiveError")
                    print(error)
                }
            }
            Button("Delete account", role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSingInView = true
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(showSingInView: .constant(false))
}
