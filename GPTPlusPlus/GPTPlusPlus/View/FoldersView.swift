//
//  FoldersView.swift
//  GPTPlusPlus
//
//  Created by Kőfaragó Nándor on 2023. 11. 21..
//

import SwiftUI

struct FoldersView: View {
    @StateObject var folderViewModel = FoldersViewModel()
    @State private var isContextMenuVisible = false
    @State private var isRenameAlertPresented = false
    @State private var newName = ""
    @State private var editingID: UUID?
    
    var body: some View {
        NavigationView {
            List(folderViewModel.folders, id: \.id) { folder in
                NavigationLink(destination: ChatsView(folder: folder)) {
                    FolderRowView(title: folder.name)
                        .contextMenu {
                            Group {
                                Button(action: {
                                    self.newName = folder.name
                                    self.editingID = folder.id
                                    self.isRenameAlertPresented = true
                                }) {
                                    Text("Rename")
                                    Image(systemName: "pencil")
                                }
                                Button(action: {
                                    self.editingID = folder.id
                                    withAnimation {
                                        folderViewModel.deleteFolder(withID: folder.id)
                                    }
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash.fill")
                                }
                            }
                        }
                }
            }
            .alert("Enter new name for folder", isPresented: $isRenameAlertPresented) {
                TextField("New name", text: $newName)
                Button("OK", action: {folderViewModel.renameFolder(withID: editingID!, to: newName)})
                Button("Cancel", role: .cancel) { }
            }
            .alert(isPresented: $folderViewModel.incorrectName) {
                Alert(
                    title: Text("Incorrect name"),
                    message: Text("Name cannot be empty!"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $folderViewModel.folderNotEmptyWarning) {
                Alert(
                    title: Text("Folder is not empty"),
                    message: Text("Are you sure you want to delete the folder and all the contained chats?"),
                    primaryButton: .destructive(Text("Yes")) {
                        withAnimation {
                            folderViewModel.deleteFolderAnyway(withID: editingID!)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("Folders")
            .navigationBarItems(trailing:
                                    HStack {
                Button(action: {
                    withAnimation {
                        folderViewModel.addNewFolder()
                    }
                }) {
                    Image(systemName: "plus")
                }
                NavigationLink(destination: SettingsView()) {
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
