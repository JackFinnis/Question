//
//  RoomView.swift
//  Question
//
//  Created by Jack Finnis on 23/10/2021.
//

import SwiftUI

struct RoomView: View {
    @Environment(\.scenePhase) var scenePhase
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
                    await roomVM.joinRoom(username: username, joinUsername: joinUsername)
                }
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
                        Task {
                            await roomVM.helper.leaveLiveRoom(username: username)
                        }
                    }
                }
            }
            .onChange(of: scenePhase) { newPhase in
                Task {
                    if newPhase == .active {
                        await roomVM.joinRoom(username: username, joinUsername: joinUsername)
                    } else {
                        await roomVM.leaveRoom(username: username, joinUsername: joinUsername)
                    }
                }
            }
        }
    }
}
