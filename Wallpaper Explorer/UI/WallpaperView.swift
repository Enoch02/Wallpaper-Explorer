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
            
            //TODO: might move to the full image preview
            /*HStack {
                Button(
                    action: {
                        downloading = true
                        downloadWallpaper()
                    },
                    label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                )
                
                Button(
                    action: {
                        
                    },
                    label: {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                    }
                )
                
                
                Button(
                    action: {},
                    label: {
                        Image(systemName: "star.fill")
                    }
                )
                
            }
            .frame(width: 200)
            .opacity(showActionBar && !downloading ? 1 : 0)
            .background(.thinMaterial)
            
            ProgressView("Downloading...")
                .progressViewStyle(.linear)
                .opacity(downloading ? 1 : 0)*/
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
    
    
    /*func downloadWallpaper() {
        let fileManager = FileManager.default
        var wallExplorerUrl: URL? = nil
        
        if let downloadsUrl = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first {
            let tempWallExplorerUrl = downloadsUrl.appending(path: "Wallpaper Explorer Downloads", directoryHint: .isDirectory)
            
            if !fileManager.fileExists(atPath: tempWallExplorerUrl.path) {
                do {
                    try fileManager.createDirectory(at: tempWallExplorerUrl, withIntermediateDirectories: true)
                    wallExplorerUrl = tempWallExplorerUrl
                } catch {
                    alertMessage = "Unable to access Downloads folder"
                    return
                }
            } else {
                wallExplorerUrl = tempWallExplorerUrl
            }
        }
        
        downloadFile(from: wallpaper.path, to: wallExplorerUrl!, completion: { result in
            switch result {
                case .success(_):
                    alertMessage = "Download Complete"
                case .failure(let failure):
                    alertMessage = "Download Failed \(failure)"
            }
            
            downloading = false
            showAlert = true
        }
        )
    }
     */
}
