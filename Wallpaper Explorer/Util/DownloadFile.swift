//
//  DownloadFile.swift
//  Wallpaper Explorer
//
//  Created by Enoch Adesanya on 02/09/2024.
//

import Foundation

func downloadFile(from url: URL, to destination: URL, completion: @escaping (Result<URL, Error>) -> Void) {
    let sourceFileName = url.lastPathComponent
    let task = URLSession.shared.downloadTask(with: url) { tempLocalUrl, response, error in
        if let error = error {
            completion(.failure(error))
        }
        
        guard let tempLocalUrl = tempLocalUrl else {
            let error = NSError(domain: "DownloadError", code: -1, userInfo: [NSLocalizedDescriptionKey: "File download failed"])
            completion(.failure(error))
            return
        }
        
        do {
            try FileManager.default.copyItem(at: tempLocalUrl, to: destination.appendingPathComponent(sourceFileName))
            completion(.success(destination))
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}
