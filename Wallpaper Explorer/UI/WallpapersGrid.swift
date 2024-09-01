//
//  WallpapersGrid.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 24/08/2024.
//

import SwiftUI

struct WallpapersGrid: View {
    @Binding var wallpapers: [Wallpaper]
    
    let gridItems = [
        GridItem(.adaptive(minimum: 400, maximum: .infinity)),
        GridItem(.adaptive(minimum: 400, maximum: .infinity)),
        GridItem(.adaptive(minimum: 400, maximum: .infinity)),
        GridItem(.adaptive(minimum: 400, maximum: .infinity))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, content: {
                ForEach(wallpapers, id: \.id, content: { wallpaper in
                    WallpaperView(wallpaper: wallpaper)
                }
                )
            }
            )
            .padding(10)
        }
    }
}
