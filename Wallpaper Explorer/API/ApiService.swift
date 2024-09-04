//
//  ApiService.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 24/08/2024.
//

import Foundation
import SwiftUI

class ApiService {
    static let shared = ApiService()
    private let BASE_URL = "https://wallhaven.cc/api/v1/"
    @AppStorage("apiKey") var apiKey = ""
    
    private init() {}
    
    func search() async throws -> [Wallpaper] {
        guard let url = URL(string: "\(BASE_URL)search") else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        let searchResult = try JSONDecoder().decode(WallpaperSearch.self, from: data)
        
        return searchResult.data
    }
    
    func search(for keyword: String) async throws -> [Wallpaper] {
        return [Wallpaper]()
    }
    
    func getUserSettings() async throws -> WHSettings? {
        if !apiKey.isEmpty {
            guard let url = URL(string: "\(BASE_URL)settings?apikey=\(apiKey)") else { return nil }
            let (data, _) = try await URLSession.shared.data(from: url)
            let settings = try JSONDecoder().decode(UserSettings.self, from: data)
            
            return settings.data
        }
        
        return nil
    }
}
