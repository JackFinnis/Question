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
            NavigationLink {
                SelectUserView(selectedUsername: $userVM.joinUsername, usernames: userVM.recentUsernames)
            } label: {
                HStack {
                    TextField("Enter Username", text: $userVM.joinUsername)
                        .disableAutocorrection(true)
                        .textContentType(.username)
                        .submitLabel(.join)
                        .onSubmit {
                            Task {
                                await userVM.submitJoinUser()
                            }
                        }
                    Text("Recent")
                        .foregroundColor(.secondary)
                }
            }
            
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
        .sheet(isPresented: $userVM.showRoomView) {
            RoomView(username: username, joinUsername: userVM.joinUsername)
        }
    }
}
