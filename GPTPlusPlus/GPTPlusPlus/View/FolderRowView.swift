//
//  FolderView.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 29..
//

import SwiftUI

struct FolderRowView: View {
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: "folder.fill")
                .foregroundColor(.blue)
            Text(title)
            Spacer()
        }
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
    }
}

struct FolderRowView_Previews: PreviewProvider {
    static var previews: some View {
        FolderRowView(title: "Test Folder")
    }
}
