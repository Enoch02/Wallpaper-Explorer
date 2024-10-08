//
//  Wallpaper.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 04/09/2024.
//

import Foundation

struct Wallpaper: Decodable {
    var id: String
    var url: URL
    var short_url: URL
    var views: Int
    var favorites: Int
    var source: String
    var purity: String
    var category: String
    var dimension_x: Int
    var dimension_y: Int
    var resolution: String
    var ratio: String
    var file_size: Int
    var file_type: String
    var created_at: String
    var colors: [String]
    var path: URL
    var thumbs: Thumbs
}

struct Thumbs: Decodable {
    var large: URL
    var original: URL
    var small: URL
}
