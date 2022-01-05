//
//  RoomView.swift
//  Question
//
//  Created by Jack Finnis on 23/10/2021.
//

import SwiftUI

struct RoomView: View {
    @EnvironmentObject var vm: ViewModel
    
    let username: String
    let joinUsername: String
    
    var body: some View {
        NavigationView {
            Group {
                if vm.joinUser == nil {
                    ProgressView("Loading room...")
                } else if vm.joinUser!.liveQuestionID == nil {
                    ProgressView("Waiting for next question...")
                } else {
                    QuestionView(username: username, joinUsername: joinUsername, questionID: vm.joinUser!.liveQuestionID!)
                }
            }
            .navigationTitle(username)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Leave Room") {
                        vm.joinUsername = nil
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    if vm.loading {
                        ProgressView()
                    }
                }
            }
        }
    }
}
