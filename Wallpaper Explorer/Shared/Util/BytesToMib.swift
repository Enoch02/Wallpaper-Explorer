//
//  BytesToMib.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 04/09/2024.
//

import Foundation

func bytesToMiB(bytes: Int) -> Double {
    let bytesPerMiB = 1024.0 * 1024.0
    return Double(bytes) / bytesPerMiB
}
