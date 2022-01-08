//
//  QuestionsView.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct QuestionsView: View {
    @ObservedObject var newQuestionVM: NewQuestionVM
    
    let username: String
    
    var body: some View {
        List(newQuestionVM.filteredQuestions) { question in
            QuestionRow(username: username, question: question)
        }
        .navigationTitle("My Questions")
        .searchable(text: $newQuestionVM.searchText.animation())
    }
}
