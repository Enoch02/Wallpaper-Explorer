//
//  WallpaperManager.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 02/11/2024.
//

import Foundation


final class WallpaperManager: ObservableObject {
    @Published
    var wallpapers = [Wallpaper]()
    
    @Published var isSFWSelected = false
    @Published var isSketchySelected = false
    @Published var isNSFWSelected = false
    @Published var isGeneralSelected = false
    @Published var isAnimeSelected = false
    @Published var isPeopleSelected = false
    
    @Published var selectedSorting = SortOptions.date_added
    @Published var selectedSortOrder = SortOrder.desc
    @Published var selectedTopRange = TopRange.one_month
    
    @Published var defaultSearchResult: DefaultWallpaperSearch? = nil
    @Published var apiSearchResult: WallpaperSearchWithKey? = nil
    @Published var userSettings: WHSettings? = nil
    
    init() {
        self.startSearch(forQuery: "", onPage: 1)
    }
    
    
    func getSettings() {
        Task {
            do {
                userSettings = try await ApiService.shared.getUserSettings()
                
                if let userSettings {
                    DispatchQueue.main.async {
                        self.isSFWSelected = userSettings.purity.contains("sfw")
                        self.isSketchySelected = userSettings.purity.contains("sketchy")
                        self.isNSFWSelected = userSettings.purity.contains("nsfw")
                        
                        self.isGeneralSelected = userSettings.categories.contains("general")
                        self.isAnimeSelected = userSettings.categories.contains("anime")
                        self.isPeopleSelected = userSettings.categories.contains("people")
                    }
                }
            } catch _ as NSError {
                //TODO
            }
        }
    }
    
    func startSearch(forQuery: String, onPage: Int) {
        Task {
            do {
                let categories = "\(self.isGeneralSelected ? "1" : "0")\(self.isAnimeSelected ? "1" : "0")\(self.isPeopleSelected ? "1" : "0")"
                let purity = "\(isSFWSelected ? "1" : "0")\(isSketchySelected ? "1" : "0")\(isNSFWSelected ? "1" : "0")"
                
                
                    switch try await ApiService.shared.search(for: forQuery, categories: categories, purity: purity, sortOption: selectedSorting,
                                                              order: selectedSortOrder, page: onPage, topRange: selectedTopRange) {
                        case .withoutKey(let defaultWallpaperSearch):
                            DispatchQueue.main.async {
                                self.wallpapers = defaultWallpaperSearch.data
                                self.defaultSearchResult = defaultWallpaperSearch
                            }
                            
                        case .withKey(let wallpaperSearchWithKey):
                            DispatchQueue.main.async {
                                self.wallpapers = wallpaperSearchWithKey.data
                                self.apiSearchResult = wallpaperSearchWithKey
                            }
                            
                        case .none:
                            print("An error has occured, try again later")
                            //TODO: handle errors
                }
            }
        }
    }
}
