//
//  Item.swift
//  Song Drop
//
//  Created by Timothy Spencer on 3/3/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
