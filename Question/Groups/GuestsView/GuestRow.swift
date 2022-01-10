//
//  GuestRow.swift
//  Question
//
//  Created by Jack Finnis on 10/01/2022.
//

import SwiftUI

struct GuestRow: View {
    @State var showConfirmationDialog = false
    @Binding var loading: Bool
    
    let username: String
    let guestUsername: String
    
    let helper = FirebaseHelper()
    
    var body: some View {
        Text(guestUsername)
            .swipeActions {
                Button {
                    showConfirmationDialog = true
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(.red)
            }
            .confirmationDialog("Remove User?", isPresented: $showConfirmationDialog) {
                Button("Cancel", role: .cancel) {}
                Button("Remove User") {
                    Task {
                        await removeUser()
                    }
                }
                Button("Block User", role: .destructive) {
                    Task {
                        await blockUser()
                    }
                }
            }
    }
    
    @MainActor
    func removeUser() async {
        loading = true
        await helper.deleteField(collection: "users", documentID: guestUsername, field: "liveJoinUsername")
        loading = false
    }
    
    @MainActor
    func blockUser() async {
        await removeUser()
        loading = true
        await helper.addElement(collection: "users", documentID: username, arrayName: "usernamesYouBlocked", element: guestUsername)
        await helper.addElement(collection: "users", documentID: guestUsername, arrayName: "usernamesBlockedYou", element: username)
        loading = false
    }
}
