//
//  JoinRoom.swift
//  Question
//
//  Created by Jack Finnis on 06/01/2022.
//

import SwiftUI

struct JoinRoom: View {
    var body: some View {
        Section {
            TextField("Enter Username", text: $userVM.joinUsername)
                .focused($focusedField, equals: .username)
                .disableAutocorrection(true)
                .textContentType(.username)
                .submitLabel(.join)
            
            Button("Join") {
                Task {
                    await userVM.submitJoinUser()
                }
            }
        } header: {
            Text("Join a Room")
        } footer: {
            Text(userVM.joinUsernameError ?? "")
        }
        .headerProminence(.increased)
    }
}
