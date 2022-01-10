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
        user.usernamesYouBlocked.filter {
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
                
                if !user.usernamesYouBlocked.isEmpty {
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
                        Text(formatter.singularPlural(singularWord: "Blocked User", count: user.usernamesYouBlocked.count))
                    }
                    .headerProminence(.increased)
                }
            }
            .searchable(text: $guestsVM.searchText.animation())
            .navigationTitle(formatter.plural(properNoun: username) + " Room")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    if guestsVM.loading {
                        ProgressView()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .bold()
                    }
                }
            }
        }
        #if !os(macOS)
        .navigationViewStyle(.stack)
        #endif
    }
}
