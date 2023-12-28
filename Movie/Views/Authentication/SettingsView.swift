//
//  SettingsView.swift
//  Movie
//
//  Created by KHJ on 2023/11/18.
//

import OSLog
import SwiftUI

struct SettingsView: View {
    @StateObject private var settingViewModel = SettingsViewModel()
    @Binding var showSingInView: Bool
    
    var body: some View {
        List {
            Button("Sign out") {
                do {
                    try settingViewModel.signOut()
                    showSingInView = true
                } catch {
                    // TODO: Combine으로 에러 처리 하기 + do catch 문은 ViewModel에서 처리
                    #warning("PassthroughSubject, onReceiveError")
                    Logger.auth.error("\(error.localizedDescription)")
                }
            }
            Button("Delete account", role: .destructive) {
                Task {
                    do {
                        try await settingViewModel.deleteAccount()
                        showSingInView = true
                    } catch {
                        Logger.auth.error("\(error.localizedDescription)")
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
