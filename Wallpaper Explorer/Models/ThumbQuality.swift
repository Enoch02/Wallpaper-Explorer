//
//  ThumbQuality.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 06/09/2024.
//

import Foundation

enum ThumbQuality: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case small = "small"
    case large = "large"
    case original = "original"
}
