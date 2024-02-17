//
//  Item.swift
//  MyCamera
//
//  Created by ゆり on 2024/02/17.
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
