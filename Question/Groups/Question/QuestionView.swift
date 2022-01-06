//
//  QuestionView.swift
//  Question
//
//  Created by Jack Finnis on 23/10/2021.
//

import SwiftUI

struct QuestionView: View {
    @StateObject var questionVM = QuestionVM()
    
    let username: String
    let questionID: String
    
    var body: some View {
        Group {
            if questionVM.question == nil {
                ProgressView("Loading question...")
            } else {
                Form {
                    Text("Question")
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
