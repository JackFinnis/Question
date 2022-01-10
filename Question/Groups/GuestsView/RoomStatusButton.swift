//
//  RoomStatusButton.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct RoomStatusButton: View {
    @State var showGuestsView = false
    
    let user: User
    let username: String
    
    let formatter = FormattingHelper()
    
    var body: some View {
        Button {
            showGuestsView = true
        } label: {
            Text(username + " - " + formatter.singularPlural(singularWord: "Guest", count: user.guestUsernames.count))
                .bold()
        }
        .sheet(isPresented: $showGuestsView) {
            GuestsView(user: user, username: username)
        }
    }
}
