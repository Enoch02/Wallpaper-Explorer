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
    
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    @State private var downloading = false
    
    init(wallpaper: Wallpaper) {
        self.wallpaper = wallpaper
        self._imageUrl = State(initialValue: wallpaper.thumbs.original)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: imageUrl) { phase in
                switch phase {
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(16/9, contentMode: .fit)
                            .cornerRadius(5)
                            .onAppear {
                                withAnimation {
                                    showActionBar = true
                                }
                            }
                        
                    case .failure(_):
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .symbolVariant(.circle)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.red)
                            
                            Text("Could not load wallpaper")
                        }
                        .onAppear {
                            withAnimation {
                                showActionBar = false
                            }
                        }
                        .frame(width: 200, height: 150)
                        
                    default:
                        ProgressView()
                            .frame(width: 200, height: 150)
                }
            }
            
            Spacer()
        }
        .alert(isPresented: $showAlert, content: {
            Alert(
                title: Text("Information"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        )
    }
}
