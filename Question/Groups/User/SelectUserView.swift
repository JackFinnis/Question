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
    
    let usernames: [String]
    
    let formatter = FormattingHelper()
    
    var body: some View {
        Form {
            Section {
                List(usernames, id: \.self) { username in
                    Button {
                        withAnimation {
                            selectedUsername = username
                            dismiss()
                        }
                    } label: {
                        Text(username)
                    }
                }
            } header: {
                Text(formatter.singularPlural(singularWord: "Recent Room", count: usernames.count))
            }
            .headerProminence(.increased)
        }
    }
}
