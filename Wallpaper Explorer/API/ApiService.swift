//
//  ApiService.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 24/08/2024.
//

import Foundation

class ApiService {
    static let shared = ApiService()
    
    private init() {}
    
    func search() async throws -> [Wallpaper] {
        guard let url = URL(string: "https://wallhaven.cc/api/v1/search") else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        let searchResult = try JSONDecoder().decode(WallpaperSearch.self, from: data)
        
        return searchResult.data
    }
}
