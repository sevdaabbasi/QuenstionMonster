//
//  Note.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 5.06.2024.
//

import Foundation

struct Note: Codable {
    var id: String
    var content: String

    init(id: String = UUID().uuidString, content: String) {
        self.id = id
        self.content = content
    }
}
