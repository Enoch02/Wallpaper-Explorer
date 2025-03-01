//
//  WallpaperView.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 31/08/2024.
//

import SwiftUI
import Kingfisher

struct WallpaperView: View {
    let wallpaper: Wallpaper
    
    @State private var imageUrl: URL
    
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    @State private var downloading = false
    @AppStorage("thumbQuality") var thumbQuality = ThumbQuality.original.rawValue
    let storedQuality = UserDefaults.standard.string(forKey: "thumbQuality") ?? ThumbQuality.original.id
	
	@State private var showFailure = false
	@State private var retryCount = 0
    
    init(wallpaper: Wallpaper) {
        self.wallpaper = wallpaper
        let qualityUrl: URL
        switch storedQuality {
            case ThumbQuality.original.id:
                qualityUrl = wallpaper.thumbs.original
            case ThumbQuality.small.id:
                qualityUrl = wallpaper.thumbs.small
            case ThumbQuality.large.id:
                qualityUrl = wallpaper.thumbs.large
            default:
                qualityUrl = wallpaper.thumbs.original
        }
        self._imageUrl = State(initialValue: qualityUrl)
    }
    
    var body: some View {
		ZStack(alignment: .bottom) {
			KFImage(imageUrl)
				.resizable()
				.onFailure { error in
					showFailure = true
				}
				.onSuccess { _ in
					showFailure = false
				}
				.aspectRatio(16/9, contentMode: .fit)
				.cornerRadius(5)
				.id(retryCount) // Force reload when retryCount changes
				.overlay {
					if showFailure {
						VStack {
							Text("Failed to load image")
								.foregroundColor(.red)
								.padding()
							
							Button("Retry") {
								retryCount += 1
							}
						}
					}
				}
		}
    }
}
