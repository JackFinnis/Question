//
//  MyRoomView.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct MyRoomView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var roomVM = RoomVM()
    @State var redundantFinished = false
    
    let username: String
    
    var body: some View {
        NavigationView {
            Group {
                if roomVM.user == nil {
                    ProgressView("Loading room...")
                } else if roomVM.user!.liveQuestionID != nil {
                    MyQuestionView(username: username, questionID: roomVM.user!.liveQuestionID!)
                }
            }
            .navigationTitle(username)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                roomVM.addUserListener(username: username)
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
