//
//  WallpaperDetailView.swift
//  Wallpaper Explorer Mobile
//
//  Created by Enoch Adesanya on 09/11/2024.
//

import SwiftUI

struct WallpaperDetailView: View {
    var wallpaper: Wallpaper
    
    var body: some View {
        Text(wallpaper.path.absoluteString)
    }
}

/*#Preview {
    WallpaperDetailView()
}*/
