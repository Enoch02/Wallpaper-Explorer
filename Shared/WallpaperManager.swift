//
//  WallpaperManager.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 02/11/2024.
//

import Combine
import Foundation
import SwiftUI



@MainActor
final class WallpaperManager: ObservableObject {
    @Published
    var wallpapers = [Wallpaper]()
    
    @Published var isSFWSelected = false
    @Published var isSketchySelected = false
    @Published var isNSFWSelected = false
    @Published var isGeneralSelected = false
    @Published var isAnimeSelected = false
    @Published var isPeopleSelected = false
    
    @AppStorage("selected_sort_option") var selectedSorting = SortOptions.date_added
    @AppStorage("sort_order") var selectedSortOrder = SortOrder.desc
    @AppStorage("selected_top_range") var selectedTopRange = TopRange.one_month
    
    @Published var defaultSearchResult: DefaultWallpaperSearch? = nil
    @Published var apiSearchResult: WallpaperSearchWithKey? = nil
    @Published var userSettings: WHSettings? = nil
    
    @Published var searchQuery = ""
    @Published var currentPage = 1
	
	@Published var showErrorAlert = false
	@Published var errorMsg = ""
    
    init() {
        self.getSettings()
        self.startSearch()
    }
    
    
    func getSettings() {
        Task {
            do {
                userSettings = try await ApiService.shared.getUserSettings()
                
                if let userSettings {
                    self.isSFWSelected = userSettings.purity.contains("sfw")
                    self.isSketchySelected = userSettings.purity.contains("sketchy")
                    self.isNSFWSelected = userSettings.purity.contains("nsfw")
                    
                    self.isGeneralSelected = userSettings.categories.contains("general")
                    self.isAnimeSelected = userSettings.categories.contains("anime")
                    self.isPeopleSelected = userSettings.categories.contains("people")
                }
            } catch _ as NSError {
                //TODO
            }
        }
    }
    
    func startSearch() {
        Task {
            do {
                let categories = "\(self.isGeneralSelected ? "1" : "0")\(self.isAnimeSelected ? "1" : "0")\(self.isPeopleSelected ? "1" : "0")"
                let purity = "\(isSFWSelected ? "1" : "0")\(isSketchySelected ? "1" : "0")\(isNSFWSelected ? "1" : "0")"
                
                
                switch try await ApiService.shared.search(for: searchQuery, categories: categories, purity: purity, sortOption: selectedSorting,
                                                          order: selectedSortOrder, page: currentPage, topRange: selectedTopRange) {
                    case .withoutKey(let defaultWallpaperSearch):
                        self.wallpapers = defaultWallpaperSearch.data
                        self.defaultSearchResult = defaultWallpaperSearch
                        
                    case .withKey(let wallpaperSearchWithKey):
                        self.wallpapers = wallpaperSearchWithKey.data
                        self.apiSearchResult = wallpaperSearchWithKey
                        
                    case .none:
                        print("An error has occured, try again later")
                }
			} catch let error as URLError {
				showErrorAlert = true
				errorMsg = "\(error.localizedDescription)"
			}
        }
		
    }
    
    func previousPage() {
        if (currentPage > 1) {
            currentPage -= 1
            startSearch()
        }
    }
    
    func nextPage() {
        currentPage += 1
        startSearch()
    }
    
    func refresh() {
        startSearch()
    }
}
