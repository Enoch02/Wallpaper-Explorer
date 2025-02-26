//
//  WallpaperDetailView.swift
//  Wallpaper Explorer Mobile
//
//  Created by Enoch Adesanya on 09/11/2024.
//

import SwiftUI

struct WallpaperDetailView: View {
	var wallpaper: Wallpaper
	
	@State private var showInfo = false
	
	var body: some View {
		ExpandedWallpaperView(wallpaper: wallpaper)
			.toolbar(
				content: {
					ToolbarItem(
						placement: .topBarTrailing,
						content: {
							Button(
								"Image Information",
								systemImage: "info.circle",
								action: {
									showInfo = true
								}
							)
						}
					)
				}
			)
			.sheet(isPresented: $showInfo) {
				VStack {
					Text("Wallpaper Information")
						.font(.title)
						.padding()
					
					Divider()
					
					VStack(alignment: .leading, spacing: 10) {
						PropertyView(property: "Resolution", value: wallpaper.resolution)
						PropertyView(property: "Category", value: wallpaper.category)
						PropertyView(property: "Purity", value: wallpaper.purity)
						PropertyView(property: "Size", value: "\(String(format: "%.2f MiB", bytesToMiB(bytes: wallpaper.file_size))) \(wallpaper.file_type)")
						PropertyView(property: "Views", value: "\(wallpaper.views)")
						PropertyView(property: "Favorites", value: "\(wallpaper.favorites)")
						PropertyLink(property: "Link", link: wallpaper.short_url)
					}
					.padding()
					
					Spacer()
					
					Button("Close") {
						showInfo = false
					}
					.padding()
				}
				.padding()
				.presentationDetents([.large])
			}
	}
}

//#Preview {
//	WallpaperDetailView()
//}
