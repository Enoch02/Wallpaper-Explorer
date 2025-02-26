//
//  Wallpaper_ExplorerApp.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 24/08/2024.
//

import SwiftUI

@main
struct Wallpaper_ExplorerApp: App {
	@StateObject var wallpaperManager = WallpaperManager()
	
    var body: some Scene {
        WindowGroup {
            MacContentView()
				.environmentObject(wallpaperManager)
        }
        
#if os(macOS)
        Settings(content: SettingsView.init)
#endif
    }
}
