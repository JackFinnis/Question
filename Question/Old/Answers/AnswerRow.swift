//
//  AnswerRow.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct AnswerRow: View {
    @State var showQuestionView = false
    
    let username: String
    let answer: Answer
    
    var body: some View {
        Button {
            showQuestionView = true
        } label: {
            Text(answer.answer ?? "No Answer")
        }
        .sheet(isPresented: $showQuestionView) {
            if let questionID = answer.questionID, let joinUsername = answer.askerUsername {
                NavigationView {
                    QuestionView(username: username, questionID: questionID, joinUsername: joinUsername)
                }
            }
        }
    }
}
