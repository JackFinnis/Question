//
//  SelectQuestionView.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct SelectQuestionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedQuestion: Question?
    
    let questions: [Question]
    
    var body: some View {
        List(questions) { question in
            Button {
                withAnimation {
                    selectedQuestion = question
                    dismiss()
                }
            } label: {
                Text(question.question ?? "No Question")
            }
        }
        .navigationTitle("Recent Questions")
    }
}
