//
//  NewSongDropViewModel.swift
//  Song Drop
//
//  Created by Timothy Spencer on 3/7/24.
//

import Foundation
import SwiftUI
import MapKit

class NewSongDropViewModel: ObservableObject {
    
    @Injected(\.spotifyRepo) var spotifyRepo
    @Injected(\.spotifyRemote) var spotifyRemote
    @Injected(\.locationService) var locationService
    
    @Published var queryFieldOpen = true
    @Published var isPlaying = false
    @Published var query = ""
    @Published var tracks: [SpotifyRepository.LightTrack] = []
    @Published var selectedRegion = MapCameraPosition.region(SongDropLocationService.DefaultRegions.standard.value())
    @Published var showMap = false
    @Published var showLocationPrompt = false
    
    @MainActor
    func refresh() async {
        tracks = await spotifyRepo.queryTracks(query: query, type: .track)
    }
    
    func playTrack(_ URI: String) {
        if spotifyRemote.appRemote.isConnected {
            spotifyRemote.play(URI)
        } else {
            spotifyRemote.appRemote.authorizeAndPlayURI(URI)
        }
    }
    
    func dropTrack() {
        Task {
            let authd = await locationService.locationAvailable() == .authorized
            
            if !authd {
                await MainActor.run {
                    showLocationPrompt = true
                }
                return
            } else {
                await MainActor.run {
                    self.selectedRegion = MapCameraPosition.region(locationService.currentRegion())
                    showMap = true
                }
            }
        }
    }
    
    func togglePlayButton() {
        if isPlaying {
            spotifyRemote.pause()
            isPlaying = false
        } else {
            spotifyRemote.resume()
            isPlaying = true
        }
    }
    
}
