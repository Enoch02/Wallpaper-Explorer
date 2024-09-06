//
//  SettingsView.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 04/09/2024.
//

import SwiftUI

struct SettingsView: View {
    //TODO: replace with something more secure
    @AppStorage("apiKey") var apiKey = ""
    @AppStorage("dataSaver") var dataSaver = false
    
    var body: some View {
        TabView {
            Form {
                TextField("API Key", text: $apiKey)
                    .help("Your Wallhaven API key")
            }
            .tabItem {
                Label("Key Management", systemImage: "globe")
            }
            
            Form {
                Toggle(
                    isOn: $dataSaver,
                    label: {
                        Text("Data Saver")
                    }
                )
                Text("Coming 🔜")
            }
            .tabItem {
                Label("Configuration", systemImage: "gearshape.2")
            }
        }
        .padding()
        .frame(width: 400)
    }
}

#Preview {
    SettingsView()
}
