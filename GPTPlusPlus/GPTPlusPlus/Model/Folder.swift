//
//  Folder.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import Foundation

class Folder: Identifiable {
    let id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
