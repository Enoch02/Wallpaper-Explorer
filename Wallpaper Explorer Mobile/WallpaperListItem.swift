//
//  WallpaperListItem.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 02/11/2024.
//

import SwiftUI

struct WallpaperListItem: View {
    let wallpaperUrl: URL
    
    var body: some View {
        AsyncImage(url: wallpaperUrl) { phase in
            switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(5)
                        .padding()
                case .failure(let error):
                    Text("An error has occoured \(error.localizedDescription)")
                default:
                    Text("An unknown error has occured?")
            }
        }
        
    }
}

#Preview {
    WallpaperListItem(wallpaperUrl: URL(string:"https://w.wallhaven.cc/full/3l/wallhaven-3lv8j6.jpg")!)
}
