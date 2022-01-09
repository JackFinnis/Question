//
//  QuestionsView.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct QuestionsView: View {
    @ObservedObject var userVM: UserVM
    
    let user: User
    let username: String
    
    var body: some View {
        Group {
            if userVM.questions.isEmpty {
                VStack {
                    Image(systemName: "questionmark")
                        .font(.title)
                    Text("No answers yet")
                }
            } else {
                List(userVM.filteredQuestions) { question in
                    QuestionRow(user: user, username: username, question: question)
                }
                .searchable(text: $userVM.questionsSearchText.animation())
            }
        }
        .navigationTitle("My Questions")
    }
}
