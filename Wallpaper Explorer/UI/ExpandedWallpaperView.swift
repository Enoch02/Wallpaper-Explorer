//
//  ExpandedWallpaperView.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 04/09/2024.
//

import SwiftUI

struct ExpandedWallpaperView: View {
    let wallpaper: Wallpaper?
    
    @State private var showActionBar = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var downloading = false
    
    @State private var retryCount = 0
    @State private var showFailure = false
    
    @AppStorage("dataSaver") var dataSaver = false
    
    var body: some View {
        if let currentWallpaper = wallpaper {
            let url = dataSaver ? currentWallpaper.thumbs.large : currentWallpaper.path
            
            VStack {
                AsyncImage(url: url) { phase in
                    switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .onAppear {
                                    retryCount = 0
                                    showFailure = false
                                    
                                    withAnimation {
                                        showActionBar = true
                                    }
                                }
                            
                        case .failure(_):
                            if showFailure {
                                VStack {
                                    Image(systemName: "exclamationmark.triangle")
                                        .symbolVariant(.circle)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.red)
                                    
                                    Text("Could not load wallpaper.")
                                    
                                    Button(
                                        action: {
                                            retryCount = 0
                                            showFailure = false
                                        },
                                        label: {
                                            Text("Retry")
                                        }
                                    ).padding()
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .onAppear {
                                    withAnimation {
                                        showActionBar = false
                                    }
                                }
                            } else {
                                ProgressView()
                                    .onAppear {
                                        retryImageLoad()
                                        
                                        withAnimation {
                                            showActionBar = false
                                        }
                                    }
                            }
                        @unknown default:
                            ProgressView()
                    }
                }
                
                ProgressView("Downloading...")
                    .progressViewStyle(.linear)
                    .opacity(downloading ? 1 : 0)
                    //.padding()
                
                HStack {
                    Button(
                        "Download",
                        systemImage: "square.and.arrow.down",
                        action: {
                            downloading = true
                            downloadWallpaper()
                        }
                    )
                    .disabled(showActionBar && !downloading ? false : true)
                    
                    Button(
                        "Crop and Download",
                        systemImage: "crop",
                        action: {
                            alertMessage = "Coming soon!"
                            showAlert = true
                        }
                    )
                    .disabled(showActionBar && !downloading ? false : true)
                    
                }
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
                .padding()
                .alert(
                    isPresented: $showAlert,
                    content: {
                        Alert(
                            title: Text("Information"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                )
            }
        } else {
            Text("Please select an image").frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func retryImageLoad() {
        // Increment retry count; show failure if retries are exhausted
        retryCount += 1
        if retryCount > 2 {
            showFailure = true
        } else {
            // Trigger view update (forcing retry)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showFailure = false
            }
        }
    }
    
    func downloadWallpaper() {
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
        
        if let wallpaper {
            downloadFile(from: wallpaper.path, to: wallExplorerUrl!, completion: { result in
                switch result {
                    case .success(_):
                        alertMessage = "Download Complete"
                    case .failure(let failure):
                        alertMessage = "Download Failed \(failure)"
                }
                
                withAnimation {
                    downloading = false
                    showAlert = true
                }
            }
            )
        }
    }
}
