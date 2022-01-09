//
//  ToggleShareButton.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct ToggleShareButton: View {
    @ObservedObject var questionVM: QuestionVM
    
    let question: Question
    let answerID: String
    
    var shared: Bool { question.sharedAnswerIDs.contains(answerID) }
    
    var body: some View {
        Button {
            Task {
                await questionVM.toggleSharedAnswer(questionID: question.id, answerID: answerID, shared: shared)
            }
        } label: {
            Image(systemName: "square.and.arrow.up" + (shared ? ".fill" : ""))
        }
        .tint(.accentColor)
    }
}
