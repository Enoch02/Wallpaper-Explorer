//
//  WallpaperListItem.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 02/11/2024.
//

import SwiftUI

struct WallpaperListItem: View {
    let wallpaperUrl: URL
    @State private var retries = 0
    
    var body: some View {
        ZStack {
            Rectangle() // Placeholder for consistent size
                .fill(Color.clear)
                .aspectRatio(16/9, contentMode: .fit)
                .cornerRadius(5)
                //.padding()
            
            AsyncImage(url: wallpaperUrl) { phase in
                switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fit)
                            .cornerRadius(5)
                            //.padding()
                    case .failure(let error):
                        if retries < 3 {
                            ProgressView()
                                .onAppear {
                                    // Retry by changing the `id` of AsyncImage
                                    retries += 1
                                }
                        } else {
                            VStack {
                                Text("Failed to load wallpaper: \(error.localizedDescription)")
                                    .multilineTextAlignment(.center)
                                Button("Retry") {
                                    retries += 1
                                }
                            }
                        }
                    default:
                        ProgressView()
                }
            }
            .id(retries) // Forces AsyncImage reload on retry
        }
        .frame(height: 200)
    }
}

#Preview {
    WallpaperListItem(wallpaperUrl: URL(string:"https://w.wallhaven.cc/full/3l/wallhaven-3lv8j6.jpg")!)
}
