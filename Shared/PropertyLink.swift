//
//  PropertyLink.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 25/01/2025.
//

import SwiftUI

struct PropertyLink: View {
	let property: String
	let link: URL?
	
	var body: some View {
		if let link {
			HStack {
				Text(property)
					.font(.headline)
					.foregroundColor(.gray)
#if os(macOS)
					.frame(width: 80, alignment: .leading)
#endif
				
				Link(link.absoluteString, destination: link)
				
#if os(macOS)
				Spacer()
#endif
			}
			.padding(.vertical, 2)
		}
	}
}

#Preview {
	PropertyLink(property: "Link", link: URL.init(string: "www.example.com"))
}
