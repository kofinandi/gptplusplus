//
//  FoldersViewModel.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import Foundation

class FoldersViewModel: ObservableObject {
    @Published var folders: [Folder]
    
    init() {
        folders = globalStorage.getAllFolders()
    }
}
