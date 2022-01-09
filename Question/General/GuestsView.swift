//
//  GuestsView.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct GuestsView: View {
    @Environment(\.dismiss) var dismiss
    @State var searchText = ""
    
    let joinUsername: String
    let guestUsernames: [String]
    
    var filteredGuestUsernames: [String] {
        guestUsernames.filter {
            searchText.isEmpty ||
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    let formatter = FormattingHelper()
    
    var body: some View {
        NavigationView {
            Group {
                if guestUsernames.isEmpty {
                    VStack {
                        Image(systemName: "person")
                            .font(.title)
                        Text("No guests yet")
                    }
                } else {
                    Form {
                        Section {
                            List(filteredGuestUsernames, id: \.self) { guestUsername in
                                Text(guestUsername)
                            }
                        } footer: {
                            Text(formatter.singularPlural(singularWord: "Guest", count: guestUsernames.count))
                        }
                    }
                    .searchable(text: $searchText.animation())
                }
            }
            .navigationTitle(joinUsername + "'s Guests")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
