//
//  RoomView.swift
//  Question
//
//  Created by Jack Finnis on 23/10/2021.
//

import SwiftUI

struct RoomView: View {
    @StateObject var roomVM = RoomVM()
    
    let username: String
    let joinUsername: String
    
    var body: some View {
        NavigationView {
            Group {
                if roomVM.user == nil {
                    ProgressView("Loading room...")
                } else if roomVM.user!.liveQuestionID == nil {
                    ProgressView("Waiting for the next question...")
                } else {
                    QuestionView(username: username, questionID: roomVM.user!.liveQuestionID!, joinUsername: joinUsername)
                }
            }
            .navigationTitle(joinUsername)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                roomVM.addUserListener(username: joinUsername)
                Task {
                    await roomVM.helper.joinRoom(username: username, joinUsername: joinUsername)
                }
            }
            .onDisappear {
                roomVM.removeListeners()
                Task {
                    await roomVM.helper.leaveRoomFully(username: username)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Leave Room") {
                        Task {
                            await roomVM.helper.leaveLiveRoom(username: username)
                        }
                    }
                }
            }
        }
    }
}
