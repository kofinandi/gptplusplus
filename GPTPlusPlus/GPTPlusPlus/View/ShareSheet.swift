//
//  Test.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 12. 06..
//

import SwiftUI

func writeToFile(filename: String, text: String) {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(filename)
        
        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
            print("Error writing to file:", error)
        }
    }
}

func getFileURL(filename: String) -> URL {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        return dir.appendingPathComponent(filename)
    }
    return URL(fileURLWithPath: "")
}

struct ShareSheet: UIViewControllerRepresentable {
    let fileURL: URL
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

