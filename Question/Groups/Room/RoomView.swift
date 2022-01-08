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
            .onAppear {
                roomVM.addUserListener(username: joinUsername)
            }
            .onDisappear {
                roomVM.removeListeners()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Leave") {
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
}
