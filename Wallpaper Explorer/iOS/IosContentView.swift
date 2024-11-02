//
//  IosContentView.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 02/11/2024.
//

import SwiftUI

struct IosContentView: View {
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
    IosContentView()
        .environmentObject(WallpaperManager())
}
