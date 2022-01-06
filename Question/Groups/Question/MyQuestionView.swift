//
//  MyQuestionView.swift
//  Question
//
//  Created by Jack Finnis on 24/10/2021.
//

import SwiftUI

struct MyQuestionView: View {
    @StateObject var questionVM = QuestionVM()
    
    let username: String
    let questionID: String
    
    var body: some View {
        Group {
            if questionVM.question == nil {
                ProgressView("Loading question...")
            } else {
                Form {
                    Text("My Question")
                    Text(questionVM.question!.question ?? "No Question")
                }
            }
        }
        .onAppear {
            questionVM.addQuestionListener(questionID: questionID)
        }
        .onDisappear {
            questionVM.removeListeners()
        }
    }
}
