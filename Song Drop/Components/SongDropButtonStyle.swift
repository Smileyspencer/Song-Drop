//
//  SongDropButtonStyle.swift
//  Song Drop
//
//  Created by Timothy Spencer on 3/7/24.
//

import Foundation
import SwiftUI

struct SongDropButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: 12)
            .padding(.all)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

}
