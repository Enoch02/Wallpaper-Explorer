//
//  PropertyView.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 25/01/2025.
//

import SwiftUI

struct PropertyView: View {
	let property: String
	let value: String
	
	var body: some View {
		HStack {
			Text(property)
				.font(.headline)
				.foregroundColor(.gray)
#if os(macOS)
				.frame(width: 80, alignment: .leading)
#endif
			
			Text(value)
				.font(.body)
				.foregroundColor(.primary)
			
#if os(macOS)
			Spacer()
#endif
		}
		.padding(.vertical, 2)
	}
}

#Preview {
	PropertyView(property: "Hello", value: "World")
}
