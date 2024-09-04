//
//  WallpaperSearchWithKey.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 04/09/2024.
//

import Foundation

struct WallpaperSearchWithKey: Decodable {
    var data: [Wallpaper]
    var meta: MetaWithKey
}

struct MetaWithKey: Decodable {
    var current_page: Int
    var last_page: Int
    var per_page: String
    var total: Int
    var query: String?
    var seed: String?
}
