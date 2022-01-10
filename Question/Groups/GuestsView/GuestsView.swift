//
//  GuestsView.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct GuestsView: View {
    @Environment(\.dismiss) var dismiss
    @State var loading = false
    @State var searchText = ""
    
    let user: User
    let username: String
    
    var filteredGuestUsernames: [String] {
        user.guestUsernames.filter {
            searchText.isEmpty ||
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var filteredBlockedGuestUsernames: [String] {
        user.usernamesYouBlocked.filter {
            searchText.isEmpty ||
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    let formatter = FormattingHelper()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    List(filteredGuestUsernames, id: \.self) { guestUsername in
                        GuestRow(loading: $loading, username: username, guestUsername: guestUsername)
                    }
                } header: {
                    Text(formatter.singularPlural(singularWord: "Guest", count: user.guestUsernames.count))
                }
                .headerProminence(.increased)
                
                if !user.usernamesYouBlocked.isEmpty {
                    Section {
                        List(filteredGuestUsernames, id: \.self) { guestUsername in
                            BlockedGuestRow(loading: $loading, username: username, guestUsername: guestUsername)
                        }
                    } header: {
                        Text(formatter.singularPlural(singularWord: "Blocked Guest", count: user.usernamesYouBlocked.count))
                    }
                    .headerProminence(.increased)
                }
            }
            .searchable(text: $searchText.animation())
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
                    if loading {
                        ProgressView()
                    }
                }
            }
        }
    }
}
