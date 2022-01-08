//
//  AnswersView.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct AnswersView: View {
    @ObservedObject var userVM: UserVM
    
    let username: String
    
    var body: some View {
        List(userVM.filteredAnswers) { answer in
            AnswerRow(username: username, answer: answer)
        }
        .navigationTitle("My Answers")
        .searchable(text: $userVM.searchText.animation())
    }
}
