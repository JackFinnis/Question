//
//  UserView.swift
//  Question
//
//  Created by Jack Finnis on 23/10/2021.
//

import SwiftUI

struct UserView: View {
    let username: String
    
    var body: some View {
        Group {
            if vm.user == nil {
                ProgressView("Loading profile...")
            } else if vm.user!.liveQuestionID != nil {
                MyQuestionView(username: username, questionID: vm.user!.liveQuestionID!)
            } else {
                
            }
        }
        .navigationTitle(username)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if vm.loading {
                    ProgressView()
                }
            }
        }
    }
}
