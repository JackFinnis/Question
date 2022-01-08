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
    @State var searchText = ""
    
    let questions: [Question]
    
    var filteredQuestions: [Question] {
        var filteredQuestions = [Question]()
        for question in questions {
            if !filteredQuestions.contains(where: { $0.question == question.question }) {
                filteredQuestions.append(question)
            }
        }
        return filteredQuestions.filter {
            searchText.isEmpty ||
            $0.question?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
    
    var body: some View {
        Group {
            if filteredQuestions.isEmpty {
                VStack {
                    Image(systemName: "questionmark")
                        .font(.title)
                    Text("No recent questions")
                }
            } else {
                List(filteredQuestions) { question in
                    Button {
                        withAnimation {
                            selectedQuestion = question
                            dismiss()
                        }
                    } label: {
                        Text(question.question ?? "No Question")
                    }
                }
                .searchable(text: $searchText.animation())
            }
        }
        .navigationTitle("Recent Questions")
    }
}
