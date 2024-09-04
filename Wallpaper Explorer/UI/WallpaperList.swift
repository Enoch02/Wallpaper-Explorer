//
//  WallpaperGrid.swift
//  Wallpaper Explorer
//

import SwiftUI

struct WallpaperList: View {
    @Binding var wallpapers: [Wallpaper]
    let onSelectedWallpaperChange: (Wallpaper) -> Void
    
    @State private var selectedWallpaper: String? = nil
    
    var body: some View {
        List(wallpapers, id: \.id, selection: $selectedWallpaper) { wallpaper in
            HStack {
                WallpaperView(wallpaper: wallpaper)
            }
        }
        .onChange(
            of: selectedWallpaper, {
                if let curentWallpaper = wallpapers.filter({ $0.id == selectedWallpaper }).first {
                    onSelectedWallpaperChange(curentWallpaper)
                }
            }
        )
        .listStyle(.sidebar)
    }
}
