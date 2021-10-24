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
                } else if vm.joinUser!.liveQuestion == nil {
                    ProgressView("Waiting for next question...")
                } else {
                    QuestionView(username: username, joinUsername: joinUsername, questionID: vm.joinUser!.liveQuestion!)
                }
            }
            .navigationTitle(username)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
