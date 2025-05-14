//
//  LocationRequiredFTU.swift
//  Song Drop
//
//  Created by Timothy Spencer on 3/5/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct LocationRequiredFTU: View {
    
    @Injected(\.locationService) var locationService
    
    var body: some View {
        VStack {
            Spacer()
            Text("In order to drop a song, please enable your location")
                .padding([.leading, .trailing], 16)
                .regularText()
            Spacer()
            Button("Confirm") {
                Task {
                    await locationService.refreshLocationManager()
                    locationService.locationManager?.requestWhenInUseAuthorization()
                }
            }
            .padding(.all, 16)
            .buttonStyle(SongDropButtonStyle())
        }
    }
}
