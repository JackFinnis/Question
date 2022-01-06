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
