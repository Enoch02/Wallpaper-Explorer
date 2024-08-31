//
//  WallpaperView.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 31/08/2024.
//

import SwiftUI

struct WallpaperView: View {
    let wallpaper: Wallpaper
    
    var body: some View {
        AsyncImage(url: wallpaper.thumbs.original) { phase in
            switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fit)
                case .failure(let error):
                    VStack {
                        Image(systemName: "questionmark")
                            .symbolVariant(.circle)
                            .font(.largeTitle)
                        
                        Text(error.localizedDescription)
                    }
                    .frame(width: 400, height: 400)
                default:
                    ProgressView()
                        .frame(width: 400, height: 400)
            }
        }
    }
}
