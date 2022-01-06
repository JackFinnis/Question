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
        Group {
            if roomVM.user == nil {
                ProgressView("Loading room...")
            } else if roomVM.user!.liveQuestionID == nil {
                ProgressView("Waiting for next question...")
            } else {
                QuestionView(username: username, questionID: roomVM.user!.liveQuestionID!)
            }
        }
        .navigationTitle(username)
        .onAppear {
            roomVM.addUserListener(username: joinUsername)
        }
        .onDisappear {
            roomVM.removeListeners()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Leave Room") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .principal) {
                if roomVM.loading {
                    ProgressView()
                }
            }
        }
    }
}