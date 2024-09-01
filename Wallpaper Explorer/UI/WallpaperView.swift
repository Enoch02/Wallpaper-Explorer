//
//  WallpaperView.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 31/08/2024.
//

import SwiftUI

struct WallpaperView: View {
    let wallpaper: Wallpaper
    @State private var imageUrl: URL
    @State private var showActionBar = false
    
    init(wallpaper: Wallpaper) {
        self.wallpaper = wallpaper
        self._imageUrl = State(initialValue: wallpaper.thumbs.original)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: imageUrl) { phase in
                switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fit)
                            .onAppear {
                                withAnimation {
                                    showActionBar = true
                                }
                            }
                        
                    case .failure(_):
                        VStack {
                            Image(systemName: "info.circle")
                                .symbolVariant(.circle)
                                .font(.largeTitle)
                            
                            Spacer(minLength: 5)
                            
                            Text("Could not load wallpaper")
                        }
                        .frame(width: 400, height: 400, alignment: .center)
                        .onAppear {
                            withAnimation {
                                showActionBar = true
                            }
                        }
                        
                    default:
                        ProgressView()
                            .frame(width: 400, height: 400)
                }
            }
            
            HStack {
                if showActionBar {
                    Button(
                        action: {},
                        label: {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                        }
                    )
                    
                    
                    Button(
                        action: {},
                        label: {
                            Image(systemName: "square.and.arrow.down")
                        }
                    )
                    
                    Button(
                        action: {},
                        label: {
                            Image(systemName: "star.fill")
                        }
                    )
                }
            }
            .padding(5)
            .background(.ultraThinMaterial)
        }
    }
}
