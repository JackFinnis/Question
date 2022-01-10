//
//  GuestsView.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct GuestsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var guestsVM: GuestsVM
    
    let user: User
    let username: String
    
    var filteredGuestUsernames: [String] {
        user.guestUsernames.filter {
            guestsVM.searchText.isEmpty ||
            $0.localizedCaseInsensitiveContains(guestsVM.searchText)
        }
    }
    
    var filteredBlockedGuestUsernames: [String] {
        user.blockedUsernames.filter {
            guestsVM.searchText.isEmpty ||
            $0.localizedCaseInsensitiveContains(guestsVM.searchText)
        }
    }
    
    let formatter = FormattingHelper()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    List(filteredGuestUsernames, id: \.self) { guestUsername in
                        GuestRow(guestsVM: guestsVM, username: username, guestUsername: guestUsername)
                    }
                } header: {
                    Text(formatter.singularPlural(singularWord: "Guest", count: user.guestUsernames.count))
                }
                .headerProminence(.increased)
                
                if !user.blockedUsernames.isEmpty {
                    Section {
                        List(filteredBlockedGuestUsernames, id: \.self) { guestUsername in
                            Text(guestUsername)
                                .swipeActions {
                                    Button {
                                        Task {
                                            await guestsVM.unblockUser(username: username, guestUsername: guestUsername)
                                        }
                                    } label: {
                                        Image(systemName: "checkmark")
                                    }
                                    .tint(.green)
                                }
                        }
                    } header: {
                        Text(formatter.singularPlural(singularWord: "Blocked Guest", count: user.blockedUsernames.count))
                    }
                    .headerProminence(.increased)
                }
            }
            .searchable(text: $guestsVM.searchText.animation())
            .navigationTitle(username + "'s Room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .bold()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if guestsVM.loading {
                        ProgressView()
                    }
                }
            }
        }
    }
}
