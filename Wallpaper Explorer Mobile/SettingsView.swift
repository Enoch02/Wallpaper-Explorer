//
//  SettingsView.swift
//  Wallpaper Explorer Mobile
//
//  Created by Enoch Adesanya on 23/11/2024.
//

import SwiftUI

struct SettingsView: View {
    let defaults = UserDefaults.standard
    @EnvironmentObject var wallpaperManager: WallpaperManager
    //TODO: replace with something more secure
    @AppStorage("apiKey") var apiKey = ""
    
    @AppStorage("dataSaver") var dataSaver = false
    @AppStorage("checkSettings") var checkSettings = true
    @AppStorage("thumbQuality") var thumbQuality = ThumbQuality.original.id
    
    var body: some View {
        List {
            Section(
                header: Text("Content Filters"),
                content: {
                    DisclosureGroup("Categories") {
                        Toggle("General", isOn: $wallpaperManager.isGeneralSelected)
                        Toggle("Anime", isOn: $wallpaperManager.isAnimeSelected)
                        Toggle("People", isOn: $wallpaperManager.isPeopleSelected)
                    }
                    
                    DisclosureGroup("Purity") {
                        Toggle("SFW", isOn: $wallpaperManager.isSFWSelected)
                        Toggle("Sketchy", isOn: $wallpaperManager.isSketchySelected)
                        Toggle("NSFW", isOn: $wallpaperManager.isNSFWSelected)
                    }
                }
            )
            
            Section(
                header: Text("Key Management"),
                content: {
                    TextField("API key", text: $apiKey)
                        .onSubmit {
                            wallpaperManager.getSettings()
                        }
                }
            )
            
            Section(
                header: Text("Data Usage"),
                content: {
                    Toggle(
                        isOn: $dataSaver,
                        label: {
                            Text("Reduce image quality for expanded wallpaper previews")
                        }
                    )
                    .focusable(false)
                    
                    // TODO: implement after i figure out how to store settings locally
                    Toggle(
                        isOn: $checkSettings,
                        label: {
                            Text("Fetch account settings on launch")
                        }
                    )
                    .focusable(false)
                    
                    Picker("Thumbnail Quality", selection: $thumbQuality) {
                        ForEach(ThumbQuality.allCases) { quality in
                            Text(quality.rawValue.capitalized)
                        }
                    }
                    .onSubmit {
                        defaults.set(thumbQuality, forKey: "thumbQuality")
                    }
                }
            )
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(WallpaperManager())
}
