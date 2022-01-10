//
//  GuestsVM.swift
//  Question
//
//  Created by Jack Finnis on 10/01/2022.
//

import Foundation
import FirebaseFirestore

@MainActor
class GuestsVM: ObservableObject {
    // MARK: - Properties
    @Published var searchText = ""
    @Published var loading = false
    
    let helper = FirebaseHelper()
    
    // MARK: - Methods
    func removeUser(guestUsername: String) async {
        loading = true
        await helper.deleteField(collection: "users", documentID: guestUsername, field: "liveJoinUsername")
        loading = false
    }
    
    func blockUser(username: String, guestUsername: String) async {
        await removeUser(guestUsername: guestUsername)
        loading = true
        await helper.addElement(collection: "users", documentID: username, arrayName: "blockedUsernames", element: guestUsername)
        loading = false
    }
    
    func unblockUser(username: String, guestUsername: String) async {
        loading = true
        await helper.removeElement(collection: "users", documentID: username, arrayName: "blockedUsernames", element: guestUsername)
        loading = false
    }
}
