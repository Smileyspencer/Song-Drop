//
//  SongDropText.swift
//  Song Drop
//
//  Created by Timothy Spencer on 3/8/24.
//

import Foundation
import SwiftUI

extension View {
    func songDropTitleText() -> some View {
        modifier(SongDropTitleText())
    }
    
    func regularText() -> some View {
        modifier(SongDropRegularText())
    }
    
    func subtitleText() -> some View {
        modifier(SongDropSubtitleText())
    }
}

struct SongDropTitleText: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Futura", size: 24))
            .fontWeight(.ultraLight)
    }
    
}

struct SongDropRegularText: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Futura", size: 16))
    }
    
}

struct SongDropSubtitleText: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Futura", size: 14))
            .fontWeight(.semibold)
    }
    
}
