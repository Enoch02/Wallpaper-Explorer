//
//  ExpandedWallpaperView.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 04/09/2024.
//

import SwiftUI

struct ExpandedWallpaperView: View {
    let wallpaper: Wallpaper?
    
    var body: some View {
        if let currentWallpaper = wallpaper {
            AsyncImage(url: currentWallpaper.path) { phase in
                switch phase {
                    case .success(let image):
                        image.resizable()
                            .resizable()
                            .scaledToFit()
                        
                    case .failure(_):
                        VStack {
                            Image(systemName: "info.circle")
                                .symbolVariant(.circle)
                                .font(.largeTitle)
                            
                            Spacer(minLength: 5)
                            
                            Text("Could not load wallpaper")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    default:
                        ProgressView()
                            .frame(width: 200, height: 150, alignment: .center)
                }
            }
        } else {
            Text("Please select an image").frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
