//
//  Material.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 5.06.2024.
//
import Foundation

enum MaterialType: String, Codable {
    case video
    case image
    case pdf
    case text
    
    var icon: String {
        switch self {
        case .video:
            return "video_icon"
        case .image:
            return "image_icon"
        case .pdf:
            return "pdf_icon"
        case .text:
            return "text_icon"
        }
    }
}

struct Material: Codable {
    var id: String
    var name: String
    var type: MaterialType
    var fileURL: URL?
}
