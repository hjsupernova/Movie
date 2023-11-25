//
//  MovieApp.swift
//  Movie
//
//  Created by KHJ on 2023/09/10.
//

import SwiftUI
import Firebase

@main
struct MovieApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var libraryViewModel = LibraryViewModel()

    var body: some Scene {
        WindowGroup {
            MovieTabView()
                .environmentObject(libraryViewModel)
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
