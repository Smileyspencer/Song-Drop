//
//  SongDropAppContainer.swift
//  Song Drop
//
//  Created by Timothy Spencer on 3/7/24.
//

import Foundation
import SwiftData
import SwiftUI

@propertyWrapper struct Injected<T> {
    private var keyPath: KeyPath<SongDropGlobalContainer, T>
    var wrappedValue: T {
        get {
            return SongDropAppManager.shared.global[keyPath: keyPath]
        }
    }
    
    init(_ keyPath: KeyPath<SongDropGlobalContainer, T>) {
        self.keyPath = keyPath
    }
}

class SongDropAppManager {
    static let shared = SongDropAppManager()
    
    var global: SongDropGlobalContainer
    
    init() {
        // Build container.
        global = SongDropGlobalContainer()
    }
}

class SongDropGlobalContainer {
    
    var spotifyRemote = SpotifyRemoteService()
    var spotifyRepo = SpotifyRepository()
    
    var logger = SongDropLogger()
    var locationService = SongDropLocationService()
    
    var authStateManager = AuthStateManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SpotifyToken.self,
        ])
        
        do {
            return try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
