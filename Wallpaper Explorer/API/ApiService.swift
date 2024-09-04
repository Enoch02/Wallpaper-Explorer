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
    
    func search() async throws -> SearchResult {
        let urlString: String
        let searchResult: SearchResult
        
        if apiKey.isEmpty {
            urlString = "\(BASE_URL)search"
            print(urlString)
            guard let url = URL(string: urlString) else { return .none }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResult = try JSONDecoder().decode(DefaultWallpaperSearch.self, from: data)
            searchResult = .withoutKey(decodedResult)
            
        } else {
            let parameters = ["apikey": apiKey]
            guard let url = buildURL(baseURL: "\(BASE_URL)search", parameters: parameters) else { return .none }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResult = try JSONDecoder().decode(WallpaperSearchWithKey.self, from: data)
            searchResult = .withKey(decodedResult)
        }
        
        return searchResult
    }
    
    //TODO: implement
    /*func search(
     for keyword: String,
     categories: String,
     purity: String,
     sortOptions:SortOptions,
     order: SortOrder) async throws -> SearchResult {
     var urlString: String
     
     if !apiKey.isEmpty {
     urlString = "\(BASE_URL)search"
     } else {
     urlString = "\(BASE_URL)search?apikey=\(apiKey)"
     }
     
     let parameters = [
     "apikey": api
     ]
     
     guard let url = URL(string: urlString) else { return SearchResult.none }
     let (data, _) = try await URLSession.shared.data(from: url)
     }*/
    
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
