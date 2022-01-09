//
//  RoomView.swift
//  Question
//
//  Created by Jack Finnis on 23/10/2021.
//

import SwiftUI

struct RoomView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var roomVM = RoomVM()
    
    let username: String
    let joinUsername: String
    
    var body: some View {
        NavigationView {
            Group {
                if roomVM.user == nil {
                    ProgressView("Loading room...")
                } else if roomVM.user!.liveQuestionID == nil {
                    ProgressView("Waiting for next question...")
                } else {
                    QuestionView(username: username, questionID: roomVM.user!.liveQuestionID!, joinUsername: joinUsername)
                }
            }
            .navigationTitle(joinUsername)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                roomVM.addUserListener(username: joinUsername)
                await roomVM.joinRoom(username: username, joinUsername: joinUsername)
            }
            .onDisappear {
                roomVM.removeListeners()
                Task {
                    await roomVM.leaveRoom(username: username, joinUsername: joinUsername)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Leave Room") {
                        dismiss()
                    }
                }
            }
        }
    }
}
