//
//  GuestRow.swift
//  Question
//
//  Created by Jack Finnis on 10/01/2022.
//

import SwiftUI

struct GuestRow: View {
    @ObservedObject var guestsVM: GuestsVM
    @State var showConfirmationDialog = false
    
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
                        await guestsVM.removeUser(guestUsername: guestUsername)
                    }
                }
                Button("Block User", role: .destructive) {
                    Task {
                        await guestsVM.blockUser(username: username, guestUsername: guestUsername)
                    }
                }
            }
    }
}
