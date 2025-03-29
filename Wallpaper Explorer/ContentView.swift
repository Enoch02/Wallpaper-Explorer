//
//  ContentView.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 24/08/2024.
//

import SwiftUI

//TODO: Write tests
struct MacContentView: View {
	@EnvironmentObject var wallpaperManager: WallpaperManager

	@State private var currentWallpaper: Wallpaper? = nil	
	@AppStorage("checkSettings") var checkSettings = true
    
    var body: some View {
        NavigationSplitView(
            sidebar: {
                VStack {
                    Form {
						Picker("Sorting", selection: $wallpaperManager.selectedSorting) {
                            ForEach(SortOptions.allCases, id: \.self) { option in
                                Text(option.rawValue)
                            }
                        }
                        .frame(minWidth: 200, alignment: .leading)
                        
                        Spacer().frame(height: 10)
                        
						Picker("Order", selection: $wallpaperManager.selectedSortOrder) {
                            ForEach(SortOrder.allCases, id: \.self) { order in
                                Text(order.rawValue)
                            }
                        }
                        
                        Spacer().frame(height: 10)
                        
						Picker("Top Range", selection: $wallpaperManager.selectedTopRange) {
                            ForEach(TopRange.allCases, id: \.self) { range in
                                Text(String(describing: range).replacingOccurrences(of: "_", with: " ").capitalized)
                            }
                        }
						.disabled(!(wallpaperManager.selectedSorting == SortOptions.toplist))
                    }
                    .padding()
                    
                    Divider()
                    
                    VStack {
                        Text("Pages").font(.headline)
                        
                        HStack {
                            Button(
                                action: {
                                    previousPage()
                                },
                                label: {
                                    Image(systemName: "arrowshape.left")
                                }
                            )
                            .keyboardShortcut("[", modifiers: [.command])
                            
							TextField("", value: $wallpaperManager.currentPage, formatter: NumberFormatter())
                                .onSubmit {
                                    updateWallpaperList()
                                }
                            
                            Button(
                                action: {
                                    nextPage()
                                },
                                label: {
                                    Image(systemName: "arrowshape.right")
                                }
                            )
                            .keyboardShortcut("]", modifiers: [.command])
                        }
                    }
                    .padding()
                    
                    Divider()
                    
                    VStack {
                        if let currentWallpaper {
                            Text("Properties").font(.headline)
                            PropertyView(property: "Resolution", value: currentWallpaper.resolution)
                            PropertyView(property: "Category", value: currentWallpaper.category)
                            PropertyView(property: "Purity", value: currentWallpaper.purity)
                            PropertyView(property: "Size", value: "\(String(format: "%.2f MiB", bytesToMiB(bytes: currentWallpaper.file_size))) - \(currentWallpaper.file_type)")
                            PropertyView(property: "Views", value: "\(currentWallpaper.views)")
                            PropertyView(property: "Favorites", value: "\(currentWallpaper.favorites)")
                            PropertyLink(property: "Link", link: currentWallpaper.short_url)
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
            },
            content: {
				if wallpaperManager.wallpapers.isEmpty {
                    Text("There's nothing here...")
                        .font(.headline)
                } else {
                    WallpaperList(
						wallpapers: $wallpaperManager.wallpapers,
                        onSelectedWallpaperChange: { wallpaper in
                            currentWallpaper = wallpaper
                        }
                    )
                    .frame(minWidth: 250, alignment: .center)
                }
            },
            detail: {
                ExpandedWallpaperView(wallpaper: currentWallpaper)
                    .padding()
            }
        )
        .frame(minWidth: 1200, minHeight: 600)
		.searchable(text: $wallpaperManager.searchQuery, placement: .automatic)
        .onSubmit(of: .search) {
			wallpaperManager.currentPage = 1
			wallpaperManager.startSearch()
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                ControlGroup("Category") {
					Toggle("General", isOn: $wallpaperManager.isGeneralSelected)
					Toggle("Anime", isOn: $wallpaperManager.isAnimeSelected)
					Toggle("People", isOn: $wallpaperManager.isPeopleSelected)
                }
            }
            
            
            ToolbarItem(placement: .automatic) {
                ControlGroup("Purity") {
					Toggle("SFW", isOn: $wallpaperManager.isSFWSelected)
					Toggle("Sketchy", isOn: $wallpaperManager.isSketchySelected)
					Toggle("NSFW", isOn: $wallpaperManager.isNSFWSelected)
                }
            }
            
            ToolbarItem(placement: .automatic) {
                Button(
                    "Refresh",
                    systemImage: "arrow.clockwise",
                    action: {
						wallpaperManager.startSearch()
                    }
                )
            }
        }
        .onAppear(
            perform: {
				if checkSettings {
					wallpaperManager.getSettings()
				}
				wallpaperManager.startSearch()
            }
        )
        .alert(
            "Error",
			isPresented: $wallpaperManager.showErrorAlert,
            actions: {
                Button("Retry") {
					wallpaperManager.startSearch()
					wallpaperManager.getSettings()
					wallpaperManager.showErrorAlert = false
                }
                
                Button("OK") {
					wallpaperManager.showErrorAlert = false
                }
            },
			message: { Text(wallpaperManager.errorMsg) }
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
        .onChange(
			of: wallpaperManager.selectedTopRange, {
				wallpaperManager.currentPage = 1
				wallpaperManager.startSearch()
            }
        )
    }
    
    func updateWallpaperList() {
		if (wallpaperManager.currentPage > 0) {
            currentWallpaper = nil
			wallpaperManager.startSearch()
        }
    }
    
    func previousPage() {
		if (wallpaperManager.currentPage > 1) {
			wallpaperManager.currentPage -= 1
            updateWallpaperList()
        }
    }
    
    func nextPage() {
		wallpaperManager.currentPage += 1
        updateWallpaperList()
    }
}

#Preview {
    MacContentView()
		.environmentObject(WallpaperManager())
}
