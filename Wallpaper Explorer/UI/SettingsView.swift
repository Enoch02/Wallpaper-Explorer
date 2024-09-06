//
//  SettingsView.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 04/09/2024.
//

import SwiftUI

struct SettingsView: View {
    let defaults = UserDefaults.standard
    //TODO: replace with something more secure
    @AppStorage("apiKey") var apiKey = ""
    
    @AppStorage("dataSaver") var dataSaver = false
    @AppStorage("checkSettings") var checkSettings = true
    @AppStorage("thumbQuality") var thumbQuality = ThumbQuality.original.id
    
    var body: some View {
        TabView {
            Form {
                TextField("API Key", text: $apiKey)
                    .help("Your Wallhaven API key")
            }
            .tabItem {
                Label("Key Management", systemImage: "globe")
            }
            
            VStack(alignment: .leading) {
                Section(header: Text("Data Usage")) {
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
            }
            .tabItem {
                Label("Configuration", systemImage: "gearshape.2")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .padding()
        .frame(minWidth: 400, minHeight: 200)
    }
}

#Preview {
    SettingsView()
}
