//
//  ContentView.swift
//  Song Drop
//
//  Created by Timothy Spencer on 3/3/24.
//

import SwiftUI
import SwiftData
import SpotifyiOS
import Alamofire
import MapKit

struct NewSongDropView: View {
    
    enum Focus: Int, Hashable{
        case query
    }
    
    @ObservedObject private var viewModel = NewSongDropViewModel()
    @FocusState var current: Focus?
    
    var body: some View {
        VStack {
            Text("Drop a new song")
                .songDropTitleText()
                .multilineTextAlignment(.center)
            
            ScrollView {
                ForEach(viewModel.tracks, id: \.id) { track in
                    VStack(alignment: .leading) {
                        Text("Track:")
                            .subtitleText()
                            .padding([.leading, .trailing], 16)
                            .padding([.bottom], 4)
                        
                        Text("\(track.name)")
                            .regularText()
                            .padding([.leading, .trailing], 16)
                            .padding([.bottom], 4)
                        
                        Text("Album:")
                            .subtitleText()
                            .padding([.leading, .trailing], 16)
                            .padding([.bottom], 4)
                        
                        Text("\(track.albumName)")
                            .regularText()
                            
                            .padding([.leading, .trailing], 16)
                            .padding([.bottom], 4)
                        
                        Text("Artists:")
                            .subtitleText()
                            .padding([.leading, .trailing], 16)
                            .padding([.bottom], 4)
                        
                        Text("\(track.artists)")
                            .regularText()
                            .padding([.leading, .trailing], 16)
                            .padding([.bottom], 4)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing, .bottom, .top])
                    .simultaneousGesture(LongPressGesture().onEnded({ _ in
                        viewModel.playTrack(track.spotifyURI)
                    }))
                    .simultaneousGesture(TapGesture().onEnded({ _ in
                        viewModel.dropTrack()
                    }))
                }
            }
            
            Divider()
            TextField("Search for a track", text: $viewModel.query)
                .focused($current, equals: .query)
                .onSubmit {
                    Task {
                        await viewModel.refresh()
                    }
                }
                .padding([.leading, .trailing, .bottom], 8)
                .textFieldStyle(.roundedBorder)
            
        }
        .sheet(isPresented: $viewModel.showLocationPrompt) {
            LocationRequiredFTU()
        }
        .sheet(isPresented: $viewModel.showMap) {
            Map(position: $viewModel.selectedRegion) {
                UserAnnotation()
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 1_000_000)
            current = .query
        }
    }
    
}

#Preview {
    NewSongDropView()
}

