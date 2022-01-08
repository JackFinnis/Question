//
//  SelectUserView.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct SelectUserView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedUsername: String
    @State var searchText = ""
    
    let usernames: [String]
    
    var filteredUsernames: [String] {
        var filteredUsernames = [String]()
        for username in usernames {
            if !filteredUsernames.contains(username) {
                filteredUsernames.append(username)
            }
        }
        return filteredUsernames.filter {
            searchText.isEmpty ||
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        Group {
            if usernames.isEmpty {
                VStack {
                    Image(systemName: "person")
                        .font(.title)
                    Text("No recent rooms")
                }
            } else {
                List(filteredUsernames, id: \.self) { username in
                    Button {
                        withAnimation {
                            selectedUsername = username
                            dismiss()
                        }
                    } label: {
                        Text(username)
                    }
                }
                .searchable(text: $searchText.animation())
            }
        }
        .navigationTitle("Recent Rooms")
    }
}
