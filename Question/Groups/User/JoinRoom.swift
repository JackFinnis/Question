//
//  JoinRoom.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct JoinRoom: View {
    @ObservedObject var userVM: UserVM
    
    let username: String
    
    var body: some View {
        Section {
            TextField("Enter Username", text: $userVM.joinUsername)
                .disableAutocorrection(true)
                .textContentType(.username)
                .submitLabel(.join)
                .onSubmit {
                    Task {
                        await userVM.submitJoinUser(username: username)
                    }
                }
            Button("Join") {
                Task {
                    await userVM.submitJoinUser(username: username)
                }
            }
        } header: {
            HStack {
                Text("Join a Room")
                Spacer()
                if !userVM.recentUsernames.isEmpty {
                    Menu {
                        ForEach(userVM.recentUsernames, id: \.self) { username in
                            Button {
                                userVM.joinUsername = username
                            } label: {
                                Text(username)
                            }
                        }
                    } label: {
                        Text("Recent")
                    }
                    .font(.none)
                }
            }
        } footer: {
            Text(userVM.joinUsernameError ?? "")
        }
        .headerProminence(.increased)
        .sheet(isPresented: $userVM.showRoomView) {
            RoomView(username: username, joinUsername: userVM.joinUsername)
        }
    }
}
