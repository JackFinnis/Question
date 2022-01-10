//
//  QuestionRow.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct QuestionRow: View {
    @State var showQuestionView = false
    
    let user: User
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
                    MyQuestionView(user: user, username: username, questionID: question.id)
                        .navigationTitle(joinUsername)
                        #if !os(macOS)
                            .navigationBarTitleDisplayMode(.inline)
                        #endif
                }
            }
        }
    }
}
