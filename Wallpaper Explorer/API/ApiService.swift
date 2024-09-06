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
    
    //TODO: navigating between pages
    func search(for keyword: String = "", categories: String, purity: String, sortOption: SortOptions, order: SortOrder, page: Int) async throws -> SearchResult {
        let searchResult: SearchResult
        var parameters = [
            "apikey": apiKey,
            "q": keyword,
            "categories": categories,
            "purity": purity,
            "sorting": String(describing: sortOption),
            "order": String(describing: order),
            "page": String(page)
        ]
        
        if apiKey.isEmpty {
            parameters.removeValue(forKey: "apikey")
            guard let url = buildURL(baseURL: "\(BASE_URL)search", parameters: parameters) else { return .none }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResult = try JSONDecoder().decode(DefaultWallpaperSearch.self, from: data)
            searchResult = .withoutKey(decodedResult)
            
        } else {
            guard let url = buildURL(baseURL: "\(BASE_URL)search", parameters: parameters) else { return .none }
            print(url.absoluteString)
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResult = try JSONDecoder().decode(WallpaperSearchWithKey.self, from: data)
            searchResult = .withKey(decodedResult)
        }
        
        return searchResult
    }
    
    //TODO: reload user settings when api key has been changed
    func getUserSettings() async throws -> WHSettings? {
        if !apiKey.isEmpty {
            guard let url = URL(string: "\(BASE_URL)settings?apikey=\(apiKey)") else { return nil }
            let (data, _) = try await URLSession.shared.data(from: url)
            let settings = try JSONDecoder().decode(UserSettings.self, from: data)
            
            return settings.data
        }
        
        return nil
    }
    
    func buildURL(baseURL: String, parameters: [String: String]) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        return components?.url
    }
}

enum SearchResult {
    case withoutKey(DefaultWallpaperSearch)
    case withKey(WallpaperSearchWithKey)
    case none
}
