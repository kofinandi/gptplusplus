//
//  ChatDetails.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import Foundation

struct ChatDetails: Identifiable {
    let id: UUID
    var title: String
    var api: APITypes
    var autoGenerateTitle: Bool
    var showMarkdown: Bool
    var folderID: UUID
}
