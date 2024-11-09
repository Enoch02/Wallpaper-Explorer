//
//  ContentView.swift
//  Wallpaper Explorer Mobile
//
//  Created by Enoch Adesanya on 06/11/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var wallpaperManager: WallpaperManager
    
    var body: some View {
        NavigationStack {
            VStack {
                if wallpaperManager.wallpapers.isEmpty {
                    Text("There's nothing here...")
                        .font(.headline)
                        .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(wallpaperManager.wallpapers, id: \.id) { wallpaper in
                                NavigationLink(destination: WallpaperDetailView(wallpaper: wallpaper)) {
                                    WallpaperListItem(wallpaperUrl: wallpaper.thumbs.original)
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Button(action: wallpaperManager.previousPage) {
                        Image(systemName: "chevron.left")
                        Text("Prev")
                    }
                    .disabled(wallpaperManager.currentPage <= 1)
                    
                    Spacer()
                    
                    Text("Page \(wallpaperManager.currentPage)")
                    
                    Spacer()
                    
                    Button(action: wallpaperManager.nextPage) {
                        Text("Next")
                        Image(systemName: "chevron.right")
                    }
                }
                .padding()
            }
            .navigationTitle("Wallpaper Explorer")
            .toolbar {
                ToolbarItem(
                    placement: .topBarTrailing,
                    content: {
                        Button(
                            "Refresh",
                            systemImage: "arrow.clockwise",
                            action: {
                                wallpaperManager.startSearch()
                            }
                        )
                    }
                )
            }
            .searchable(text: $wallpaperManager.searchQuery)
            .onSubmit(of: .search) {
                wallpaperManager.startSearch()
            }
        }
    }
}

#Preview {
    ContentView()
}
