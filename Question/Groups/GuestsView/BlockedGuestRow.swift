//
//  BlockedGuestRow.swift
//  Question
//
//  Created by Jack Finnis on 10/01/2022.
//

import SwiftUI

struct BlockedGuestRow: View {
    @Binding var loading: Bool
    
    let username: String
    let guestUsername: String
    
    let helper = FirebaseHelper()
    
    var body: some View {
        Text(guestUsername)
            .swipeActions {
                Button {
                    Task {
                        await unblockUser()
                    }
                } label: {
                    Image(systemName: "checkmark.seal")
                }
                .tint(.green)
            }
    }
    
    @MainActor
    func unblockUser() async {
        loading = true
        await helper.removeElement(collection: "users", documentID: username, arrayName: "usernamesYouBlocked", element: guestUsername)
        await helper.removeElement(collection: "users", documentID: guestUsername, arrayName: "usernamesBlockedYou", element: username)
        loading = false
    }
}
