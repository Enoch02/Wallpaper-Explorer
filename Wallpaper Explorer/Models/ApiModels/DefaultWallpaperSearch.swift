//
//  DefaultWallpaperSearch.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 31/08/2024.
//

import Foundation

struct DefaultWallpaperSearch: Decodable {
    var data: [Wallpaper]
    var meta: Meta
}

struct Meta: Decodable {
    var current_page: Int
    var last_page: Int
    var per_page: Int
    var total: Int
    var query: String?
    var seed: String?
}
