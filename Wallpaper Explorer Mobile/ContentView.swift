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
        ScrollView {
            LazyVStack {
                ForEach(wallpaperManager.wallpapers, id: \.id) { wallpaper in
                    WallpaperListItem(wallpaperUrl: wallpaper.thumbs.original)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
