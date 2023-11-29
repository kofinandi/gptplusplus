//
//  FoldersView.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import SwiftUI

struct FoldersView: View {
    @StateObject var folderViewModel = FoldersViewModel()
    
    var body: some View {
        NavigationView {
            List(folderViewModel.folders, id: \.id) { folder in
                NavigationLink(destination: ChatsView(folder: folder)) {
                    FolderRowView(title: folder.name)
                }
            }
            .navigationTitle("Folders")
            .navigationBarItems(trailing:
                                    HStack {
                Button(action: {
                    print("Add new folder")
                }) {
                    Image(systemName: "plus")
                }
                Button(action: {
                    print("Add new folder")
                }) {
                    Image(systemName: "gearshape")
                }
            }
            )
        }
    }
}

struct Folders_Previews: PreviewProvider {
    static var previews: some View {
        FoldersView()
    }
}
