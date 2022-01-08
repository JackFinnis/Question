//
//  QuestionRow.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct QuestionRow: View {
    @State var showQuestionView = false
    
    let username: String
    let question: Question
    
    var body: some View {
        Button {
            showQuestionView = true
        } label: {
            Text(question.question ?? "No Question")
        }
        .sheet(isPresented: $showQuestionView) {
            if let joinUsername = question.askerUsername {
                NavigationView {
                    MyQuestionView(username: username, questionID: question.id)
                        .navigationTitle(joinUsername)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}
