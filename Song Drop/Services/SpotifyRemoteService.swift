//
//  SpotifyRemoteService.swift
//  Song Drop
//
//  Created by Timothy Spencer on 3/4/24.
//

import Foundation
import SpotifyiOS

class SpotifyRemoteService: NSObject {
    
    private let schemeName = "tspencerSongDropURLScheme"
    let appRemote: SPTAppRemote
    var accessToken: String?
    
    override init() {
        let url = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
        // Integration is deleted from Spotify. I am quickly doing this because app is not deployed and I want to
        // make application accessible.
        let config = SPTConfiguration(clientID: "c47fe2ebb6914487b1b6ca7e37acf268",
                                      redirectURL: url)
        self.appRemote = SPTAppRemote(configuration: config, logLevel: .debug)
        super.init()
    }
    
    func handleAuthenticationRedirect(url: URL) {
        let parameters = self.appRemote.authorizationParameters(from: url)
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            self.appRemote.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
            self.appRemote.connectionParameters.accessToken = accessToken
            self.appRemote.delegate = self
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print(errorDescription)
        }
    }
    
    func play(_ URI: String) {
        if let playerAPI = self.appRemote.playerAPI {
            playerAPI.play(URI, asRadio: false) { result, error in
                if let error = error {
                    ERROR(error.localizedDescription)

                }
            }
        }
    }
    
    func resume() {
        if let playerAPI = self.appRemote.playerAPI {
            playerAPI.resume()
        }
    }
    
    func pause() {
        if let playerAPI = self.appRemote.playerAPI {
            playerAPI.pause()
        }
    }
    
}

extension SpotifyRemoteService: SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) { 
        
    }
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) { }
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) { }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        
        
    }
    
}
