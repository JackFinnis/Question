//
//  QuestionView.swift
//  Question
//
//  Created by Jack Finnis on 23/10/2021.
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var vm: ViewModel
    
    let username: String
    let joinUsername: String
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
        .onAppear {
            vm.addQuestionListener(questionID: questionID)
        }
        .onDisappear {
            vm.removeQuestionListener()
        }
    }
}
