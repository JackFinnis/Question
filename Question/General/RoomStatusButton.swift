//
//  RoomStatusButton.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct RoomStatusButton: View {
    @State var showGuestsView = false
    
    let joinUsername: String
    let guestUsernames: [String]
    
    let formatter = FormattingHelper()
    
    var body: some View {
        Button {
            showGuestsView = true
        } label: {
            Text(joinUsername + " - " + formatter.singularPlural(singularWord: "Guest", count: guestUsernames.count))
                .bold()
        }
        .sheet(isPresented: $showGuestsView) {
            GuestsView(joinUsername: joinUsername, guestUsernames: guestUsernames)
        }
    }
}
