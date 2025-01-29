//
//  ContentView.swift
//  Wallpaper Explorer Mobile
//
//  Created by Enoch Adesanya on 06/11/2024.
//

import SwiftUI

//TODO: improve landscape UI
struct ContentView: View {
	@EnvironmentObject var wallpaperManager: WallpaperManager
	
	@State private var showSorting = false
	@State private var showOrder = false
	
	var body: some View {
		NavigationStack {
			VStack {
				if wallpaperManager.wallpapers.isEmpty {
					Text("There's nothing here...")
						.font(.headline)
						.frame(maxHeight: .infinity)
				} else {
					ScrollViewReader { proxy in
						ScrollView {
							LazyVStack {
								// Invisible top anchor
								Color.clear
									.frame(height: 1)
									.id("top")
								
								ForEach(wallpaperManager.wallpapers, id: \.id) { wallpaper in
									NavigationLink(destination: WallpaperDetailView(wallpaper: wallpaper)) {
										WallpaperListItem(wallpaperUrl: wallpaper.thumbs.original)
									}
								}
							}
						}
						.onChange(
							of: wallpaperManager.wallpapers.first?.id, {
								withAnimation {
									proxy.scrollTo("top")
								}
							}
						)
					}
				}
				
				HStack {
					Button(action: { Task{ wallpaperManager.previousPage() } }) {
						Image(systemName: "chevron.left")
						Text("Prev")
					}
					.disabled(wallpaperManager.currentPage <= 1)
					
					Spacer()
					
					Text("Page \(wallpaperManager.currentPage)")
					
					Spacer()
					
					Button( action: { Task { wallpaperManager.nextPage() } }) {
						Text("Next")
						Image(systemName: "chevron.right")
					}
				}
				.padding()
			}
			.navigationTitle("Wallpaper Explorer")
			.toolbar {
				ToolbarItem(
					placement: .topBarLeading,
					content: {
						NavigationLink(
							destination: SettingsView().environmentObject(wallpaperManager),
							label: {
								Button(
									"Settings",
									systemImage: "gear",
									action: {
										
									}
								)
							}
						)
					}
				)
				
				ToolbarItem(
					placement: .topBarTrailing,
					content: {
						Button(
							"Refresh",
							systemImage: "arrow.clockwise",
							action: {
								wallpaperManager.refresh()
							}
						)
					}
				)
				
				ToolbarItem(
					placement: .topBarTrailing,
					content: {
						Button(
							"Sorting",
							systemImage: "line.3.horizontal.decrease.circle",
							action: {
								showSorting = true
							}
						)
					}
				)
				
				ToolbarItem(
					placement: .topBarTrailing,
					content: {
						Button(
							"Order",
							systemImage: "arrow.up.arrow.down",
							action: {
								showOrder = true
							}
						)
					}
				)
			}
			.searchable(text: $wallpaperManager.searchQuery)
			.searchPresentationToolbarBehavior(.avoidHidingContent)
			.onSubmit(of: .search) {
				wallpaperManager.startSearch()
			}
			.confirmationDialog(
				"Sort Options [currently '\(wallpaperManager.selectedSorting.rawValue)']",
				isPresented: $showSorting,
				titleVisibility: .visible,
				actions: {
					ForEach(SortOptions.allCases, id: \.self) { option in
						Button(option.rawValue) {
							wallpaperManager.selectedSorting = option
							showSorting = false
						}
					}
				}
			)
			.confirmationDialog(
				"Order [currently '\(wallpaperManager.selectedSortOrder.rawValue)']",
				isPresented: $showOrder,
				titleVisibility: .visible,
				actions: {
					ForEach(SortOrder.allCases, id: \.self) { option in
						Button(option.rawValue) {
							wallpaperManager.selectedSortOrder = option
							showOrder = false
						}
					}
				}
			)
			.onChange(
				of: wallpaperManager.selectedSorting, {
					wallpaperManager.currentPage = 1
					wallpaperManager.startSearch()
				}
			)
			.onChange(
				of: wallpaperManager.selectedSortOrder, {
					wallpaperManager.currentPage = 1
					wallpaperManager.startSearch()
				}
			)
		}
	}
}

#Preview {
	ContentView()
}
