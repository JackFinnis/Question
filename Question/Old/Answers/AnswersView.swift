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
        Group {
            if userVM.answers.isEmpty {
                VStack {
                    Image(systemName: "square.and.pencil")
                        .font(.title)
                    Text("No answers yet")
                }
            } else {
                List(userVM.filteredAnswers) { answer in
                    AnswerRow(username: username, answer: answer)
                }
                .searchable(text: $userVM.answersSearchText.animation())
            }
        }
        .navigationTitle("My Answers")
    }
}
