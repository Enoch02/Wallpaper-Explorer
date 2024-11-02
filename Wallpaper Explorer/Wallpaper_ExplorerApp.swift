//
//  Wallpaper_ExplorerApp.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 24/08/2024.
//

import SwiftUI

@main
struct Wallpaper_ExplorerApp: App {
    let wallpaperManager = WallpaperManager()
    
    var body: some Scene {
        WindowGroup {
#if os(macOS)
            MacContentView()
#else
            IosContentView()
                .environmentObject(wallpaperManager)
#endif
        }
        
#if os(macOS)
        Settings(content: SettingsView.init)
#endif
    }
}
