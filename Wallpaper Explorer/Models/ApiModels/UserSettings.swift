//
//  UserSettings.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 04/09/2024.
//

import Foundation

struct UserSettings: Decodable {
    var data: WHSettings
}

struct WHSettings: Decodable {
    var thumb_size: String
    var per_page: String
    var purity: [String]
    var categories: [String]
    var resolutions: [String]
    var aspect_ratios: [String]
    var toplist_range: String
    var tag_blacklist: [String]
    var user_blacklist: [String]
    var ai_art_filter: Int
}
