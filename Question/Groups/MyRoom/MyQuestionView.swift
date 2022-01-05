//
//  MyQuestionView.swift
//  Question
//
//  Created by Jack Finnis on 24/10/2021.
//

import SwiftUI

struct MyQuestionView: View {
    @EnvironmentObject var vm: ViewModel
    
    let username: String
    let questionID: String
    
    var body: some View {
        Group {
            if vm.question == nil {
                ProgressView("Loading question...")
            } else {
                Form {
                    Text(vm.question!.question ?? "No Question")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Stop", role: .destructive) {
                    vm.stopLiveQuestion(username: username)
                }
            }
        }
        .onAppear {
            vm.addQuestionListener(questionID: questionID)
        }
        .onDisappear {
            vm.removeQuestionListener()
        }
    }
}
