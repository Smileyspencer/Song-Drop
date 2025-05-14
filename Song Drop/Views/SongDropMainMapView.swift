//
//  SongDropMainMapView.swift
//  Song Drop
//
//  Created by Timothy Spencer on 3/5/24.
//

import Foundation
import SwiftUI
import MapKit
import FirebaseAuth

struct SongDropMainMapView: View {
    
    @Injected(\.locationService) var locationService
    
    @State var region = MapCameraPosition.region(SongDropLocationService.DefaultRegions.standard.value())
    @State var selectedPin: Int = -1
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Songs near you")
                    .songDropTitleText()
                Map(position: $region) {
                        Annotation("Drop", coordinate: locationService.currentLocation()) {
                            
                                Text("Song title A")
                                    .foregroundStyle(.white)
                                    .padding(.all, 16)
                                Text("Shared by user B")
                                    .foregroundStyle(.white)
                                    .padding(.all, 16)
                                Button("Details") {
                                    withAnimation {
                                        if selectedPin == 1 {
                                            selectedPin = -1
                                        } else {
                                            selectedPin = 1
                                        }
                                    }
                                }
                                .foregroundStyle(.white)
                                
                                if selectedPin == 1 {
                                    // Moves in from the bottom
                                    Text("Song title A")
                                        .transition(.move(edge: .bottom))

                                    // Moves in from leading out, out to trailing edge.
                                    Text("Artist B")
                                        .transition(.move(edge: .bottom))

                                    // Starts small and grows to full size.
                                    Text("Album C")
                                        .transition(.move(edge: .bottom))
                                }
                        }
                }
                .task {
                    try? await Task.sleep(nanoseconds: 1_000_000)
                    await MainActor.run {
                        self.region = MapCameraPosition.region(locationService.currentRegion())
                    }
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding([.leading, .trailing], 16)
                
                NavigationLink("Song Drop", destination: NewSongDropView())
                    .padding([.leading, .trailing, .bottom], 16)
                    .buttonStyle(SongDropButtonStyle())

            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                Button {
                    let firebaseAuth = Auth.auth()
                    do {
                      try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                      print("Error signing out: %@", signOutError)
                    }
                } label: {
                    Image(systemName: "person.crop.circle")
                }
            }
        }
    }
    
}
