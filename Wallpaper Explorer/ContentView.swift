//
//  ContentView.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 24/08/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var searchQuery = ""
    @State private var isSFWSelected = false
    @State private var isSketchySelected = false
    @State private var isNSFWSelected = false
    @State private var isGeneralSelected = false
    @State private var isAnimeSelected = false
    @State private var isPeopleSelected = false
    
    @State private var selectedSorting = SortOptions.date_added
    @State private var selectedSortOrder = SortOrder.desc                                                   
    
    @State private var defaultSearchResult: DefaultWallpaperSearch? = nil
    @State private var apiSearchResult: WallpaperSearchWithKey? = nil
    @State private var wallpapers = [Wallpaper]()
    @State private var currentWallpaper: Wallpaper? = nil
    
    @State private var userSettings: WHSettings? = nil
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationSplitView(
            sidebar: {
                VStack {
                    Form {
                        Picker("Sorting", selection: $selectedSorting) {
                            ForEach(SortOptions.allCases, id: \.self) { option in
                                Text(option.rawValue)
                            }
                        }
                        .frame(minWidth: 200, alignment: .leading)
                        
                        Spacer().frame(height: 20)
                        
                        Picker("Order", selection: $selectedSortOrder) {
                            ForEach(SortOrder.allCases, id: \.self) { order in
                                Text(order.rawValue)
                            }
                        }
                    }
                    .padding()
                    
                    Divider()
                    
                    VStack {
                        if let currentWallpaper {
                            Text("Properties").font(.headline)
                            PropertyView(property: "Resolution", value: currentWallpaper.resolution)
                            PropertyView(property: "Category", value: currentWallpaper.category)
                            PropertyView(property: "Purity", value: currentWallpaper.purity)
                            PropertyView(property: "Size", value: "\(String(format: "%.2f MiB", bytesToMiB(bytes: currentWallpaper.file_size))) - \(currentWallpaper.file_type)")
                            PropertyView(property: "Views", value: "\(currentWallpaper.views)")
                            PropertyView(property: "Favorites", value: "\(currentWallpaper.favorites)")
                            PropertyLink(property: "Link", link: currentWallpaper.short_url)
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
            },
            content: {
                if wallpapers.isEmpty {
                    Text("There's nothing here...")
                        .font(.headline)
                } else {
                    WallpaperList(
                        wallpapers: $wallpapers,
                        onSelectedWallpaperChange: { wallpaper in
                            currentWallpaper = wallpaper
                        }
                    )
                    .frame(minWidth: 250, alignment: .center)
                }
            },
            detail: {
                ExpandedWallpaperView(wallpaper: currentWallpaper)
                    .padding()
            }
        )
        .frame(minWidth: 1200, minHeight: 600)
        .searchable(text: $searchQuery, placement: .automatic)
        .onSubmit(of: .search) {
            startSearch()
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                ControlGroup("Category") {
                    Toggle("General", isOn: $isGeneralSelected)
                    Toggle("Anime", isOn: $isAnimeSelected)
                    Toggle("People", isOn: $isPeopleSelected)
                }
            }
            
            
            ToolbarItem(placement: .automatic) {
                ControlGroup("Purity") {
                    Toggle("SFW", isOn: $isSFWSelected)
                    Toggle("Sketchy", isOn: $isSketchySelected)
                    Toggle("NSFW", isOn: $isNSFWSelected)
                }
            }
            
            ToolbarItem(placement: .automatic) {
                Button(
                    "Refresh",
                    systemImage: "arrow.clockwise",
                    action: {
                        startSearch()
                    }
                )
            }
        }
        .onAppear(
            perform: {
                getSettings()
                startSearch()
            }
        )
        .alert(
            isPresented: $showErrorAlert,
            content: {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        )
        .onChange(of: selectedSorting, { startSearch() })
        .onChange(of: selectedSortOrder, { startSearch() })
    }
    
    func startSearch() {
        clearExistingData()
        
        Task {
            do {
                let categories = "\(isGeneralSelected ? "1" : "0")\(isAnimeSelected ? "1" : "0")\(isPeopleSelected ? "1" : "0")"
                let purity = "\(isSFWSelected ? "1" : "0")\(isSketchySelected ? "1" : "0")\(isNSFWSelected ? "1" : "0")"
                
                switch try await ApiService.shared.search(for: searchQuery, categories: categories, purity: purity, sortOption: selectedSorting, order: selectedSortOrder) {
                    case .withoutKey(let defaultWallpaperSearch):
                        wallpapers = defaultWallpaperSearch.data
                        defaultSearchResult = defaultWallpaperSearch
                        
                    case .withKey(let wallpaperSearchWithKey):
                        wallpapers = wallpaperSearchWithKey.data
                        apiSearchResult = wallpaperSearchWithKey
                        
                    case .none:
                        errorMessage = "Could not load wallpaper data!"
                        showErrorAlert = true
                }
            }
        }
    }
    
    func clearExistingData() {
        if !wallpapers.isEmpty {
            wallpapers = [Wallpaper]()
            currentWallpaper = nil
            defaultSearchResult = nil
            apiSearchResult = nil
        }
    }
    
    func getSettings() {
        Task {
            do {
                userSettings = try await ApiService.shared.getUserSettings()
                
                if let userSettings {
                    isSFWSelected = userSettings.purity.contains("sfw")
                    isSketchySelected = userSettings.purity.contains("sketchy")
                    isNSFWSelected = userSettings.purity.contains("nsfw")
                    
                    isGeneralSelected = userSettings.categories.contains("general")
                    isAnimeSelected = userSettings.categories.contains("anime")
                    isPeopleSelected = userSettings.categories.contains("people")
                }
            } catch let error as NSError {
                errorMessage = error.localizedDescription
                withAnimation {
                    showErrorAlert = true
                }
            }
        }
    }
    
    private func PropertyView(property: String, value: String) -> some View {
        HStack {
            Text(property)
                .font(.headline)
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.vertical, 2)
    }
    
    private func PropertyLink(property: String, link: URL) -> some View {
        HStack {
            Text(property)
                .font(.headline)
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)
            
            Link(link.absoluteString, destination: link)
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ContentView()
}
