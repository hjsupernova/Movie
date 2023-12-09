//
//  Logger.swift
//  Movie
//
//  Created by KHJ on 2023/12/09.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.kim.hyunjin.Movie"
    static let auth = Logger(subsystem: subsystem, category: "auth")
    static let network = Logger(subsystem: subsystem, category: "network")
    static let fileManager = Logger(subsystem: subsystem, category: "fileManager")
    static let firestore = Logger(subsystem: subsystem, category: "firestore")
    static let userDefaults = Logger(subsystem: subsystem, category: "userDefaults")
    static let parser = Logger(subsystem: subsystem, category: "parser")
}
