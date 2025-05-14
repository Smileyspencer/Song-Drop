//
//  SpotifyRepository.swift
//  Song Drop
//
//  Created by Timothy Spencer on 3/4/24.
//

import Foundation
import Alamofire
import SwiftData

@Model
class SpotifyToken: Codable {
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiration = "expires_in"
    }
    
    var accessToken: String
    var tokenType: String
    var expiration: Int
    var expirationDate: Date?
    
    init(accessToken: String, tokenType: String, expiration: Int, expirationDate: Date?) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiration = expiration
        self.expirationDate = expirationDate
    }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        expiration = try container.decode(Int.self, forKey: .expiration)
        
        // Set expiration from generation.
        var components = DateComponents()
        components.second = (expiration - 60) // Give a little wiggle room to avoid downtime.
        if let expirationDate = Calendar.current.date(byAdding: components, to: Date()) {
            self.expirationDate = expirationDate
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(tokenType, forKey: .tokenType)
        try container.encode(expiration, forKey: .expiration)
    }
    
}

class SpotifyRepository {
    
    @Injected(\.sharedModelContainer) var sharedModelContainer
    
    enum QueryType: String {
        case album, artist, playlist, track, show, episode, audiobook
    }
    
    // Constants.
    private let clientId = "c47fe2ebb6914487b1b6ca7e37acf268"
    private let clientSecret = "91e287f9df5945ba9abc5564e5b90f08"
    private let contentType = "application/x-www-form-urlencoded"
    
    func getAccessToken() async -> SpotifyToken? {
        let tokens = await MainActor.run {
            let descriptor = FetchDescriptor<SpotifyToken>(sortBy: [SortDescriptor(\.expiration, order: .forward)])
            let tokens = try? sharedModelContainer.mainContext.fetch<SpotifyToken>(descriptor)
            return tokens
        }
        
        // Check for token.
        if (tokens ?? []).count == 1,
           let storedToken = tokens?.first {
            
            // Ensure token is still valid.
            if let expiration = storedToken.expirationDate,
               Date() < expiration {
                return storedToken
            }
        }
        
        if tokens?.count ?? 0 > 1 {
            await MainActor.run {
                try? sharedModelContainer.mainContext.delete(model: SpotifyToken.self)
            }
        }
        
        let params: Parameters = [
            "grant_type": "client_credentials",
            "client_id": "\(clientId)",
            "client_secret": "\(clientSecret)"
        ]
        
        let request = AF.request("https://accounts.spotify.com/api/token",
                                 method: .post,
                                 parameters: params,
                                 headers: [
                                    "Content-Type": "\(contentType)",
                                 ],
                                 interceptor: .retryPolicy)
            .serializingDecodable(SpotifyToken.self)
        let response = await request.response
        switch response.result {
        case .success(let token):
            await MainActor.run {
                // Delete all tokens, insert new token.
                try? sharedModelContainer.mainContext.delete(model: SpotifyToken.self)
                sharedModelContainer.mainContext.insert(token)
            }
            return token
        case .failure(let error):
            ERROR("Error in request: \(error)")
            return nil
        }
    }
    
    struct LightTrack: Identifiable {
        var id = UUID()
        var name: String
        var albumName: String
        var artists: String
        var spotifyURI: String
    }
    
    func queryTracks(query: String, type: QueryType) async -> [LightTrack] {
        var names: [LightTrack] = []
        switch await queryAPI(query: query, type: type) {
        case .success(let json):
            let tracksObj = json.tracks
            if let tracks = tracksObj?.items {
                for track in tracks {
                    let name = track.name ?? "(No track name)"
                    let spotifyURI = track.uri ?? ""
                    let albumName = track.album?.name ?? "(No album)"
                    let artists = (track.artists ?? []).compactMap { artist in
                        return artist.name
                    }.reduce("", { partialResult, artist in
                        "\(partialResult == "" ? "" : "\(partialResult),") \(artist)"
                    })
                    
                    let nameS = LightTrack(name: name, albumName: albumName, artists: artists, spotifyURI: spotifyURI)
                    names.append(nameS)
                }
            }
            print(json)
        case .failure(let error):
            ERROR("Error in request: \(error)")
        }
        return names
    }
    
    func queryAPI(query: String, type: QueryType, market: String = "US", limit: Int = 5) async -> Result<Json4Swift_Base, AFError> {
        let params: Parameters = [
            "q": "\(query)",
            "type": "\(type.rawValue)",
            "market": "\(market)",
            "limit": "\(limit)"
        ]
        
        var headers: HTTPHeaders = [
            "Content-Type": "\(contentType)",
        ]
        
        // Refresh token if needed before request.
        
        if let generatedToken = await getAccessToken() {
            headers["Authorization"] = "Bearer \(generatedToken.accessToken)"
        }
        
        let request = AF.request("https://api.spotify.com/v1/search",
                                 method: .get,
                                 parameters: params,
                                 headers: headers,
                                 interceptor: .retryPolicy)
            .serializingDecodable(Json4Swift_Base.self)
        let response = await request.response
        return response.result
    }
    
}
