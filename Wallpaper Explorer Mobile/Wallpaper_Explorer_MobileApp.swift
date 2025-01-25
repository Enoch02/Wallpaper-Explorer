//
//  Wallpaper_Explorer_MobileApp.swift
//  Wallpaper Explorer Mobile
//
//  Created by Enoch Adesanya on 06/11/2024.
//

import SwiftUI

@main
struct Wallpaper_Explorer_MobileApp: App {
    @StateObject var wallpaperManager = WallpaperManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(wallpaperManager)
        }
    }
}
