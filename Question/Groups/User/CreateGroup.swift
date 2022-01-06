//
//  CreateGroup.swift
//  Question
//
//  Created by Jack Finnis on 05/01/2022.
//

import SwiftUI

struct CreateGroup: View {
    @ObservedObject var userVM: UserVM
    @FocusState var focusedField: Field?
    
    let username: String
    
    var body: some View {
        Group {
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
            
            Section {
                TextField("Enter Question", text: $userVM.newQuestion)
                    .focused($focusedField, equals: .question)
                    .submitLabel(.go)
                
                Button("Start") {
                    Task {
                        await userVM.startQuestion(username: username)
                    }
                }
            } header: {
                Text("Start a Question")
            } footer: {
                Text(userVM.newQuestionError ?? "")
            }
            .headerProminence(.increased)
        }
        .onSubmit {
            Task {
                if focusedField == .username {
                    await userVM.submitJoinUser()
                } else {
                    await userVM.startQuestion(username: username)
                }
            }
        }
        .sheet(isPresented: $userVM.showRoomView) {
            RoomView(username: username, joinUsername: userVM.joinUsername)
        }
        .sheet(isPresented: $userVM.showMyRoomView) {
            MyRoom(username: username)
        }
    }
}
