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
    @State private var selectedSortOrder = SortOrder.descending
    
    @State private var wallpapers = [Wallpaper]()
    @State private var currentWallpaper: Wallpaper? = nil
    
    var body: some View {
        NavigationSplitView(
            sidebar: {
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
                .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
            },
            content: {
                WallpaperList(
                    wallpapers: $wallpapers,
                    onSelectedWallpaperChange: { wallpaper in
                        currentWallpaper = wallpaper
                    }
                )
                    .frame(minWidth: 250, alignment: .center)
            },
            detail: {
                if let currentWallpaper = currentWallpaper {
                    AsyncImage(url: currentWallpaper.path) { phase in
                        switch phase {
                            case .success(let image):
                                image.resizable()
                                    .resizable()
                                    .scaledToFit()
                                
                            case .failure(_):
                                VStack {
                                    Image(systemName: "info.circle")
                                        .symbolVariant(.circle)
                                        .font(.largeTitle)
                                    
                                    Spacer(minLength: 5)
                                    
                                    Text("Could not load wallpaper")
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
                            default:
                                ProgressView()
                                    .frame(width: 200, height: 150, alignment: .center)
                        }
                    }
                } else {
                    Text("Please select an image").frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        )
        .frame(minWidth: 1200, minHeight: 600)
        .searchable(text: $searchQuery, placement: .automatic)
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
                }.controlGroupStyle(.automatic)
            }
            
            ToolbarItem(placement: .automatic) {
                Button("Refresh", systemImage: "arrow.clockwise",
                       action: {
                    loadContent()
                }
                )
            }
        }
        .onAppear(perform: loadContent)
    }
    
    //TODO: temporary
    func loadContent() {
        if !wallpapers.isEmpty {
            wallpapers = [Wallpaper]()
        }
        
        Task {
            do {
                wallpapers = try await ApiService.shared.search()
            } catch let error as NSError {
                print(error.localizedDescription)
                print(error.userInfo)
            }
        }
    }
}

#Preview {
    ContentView()
}
