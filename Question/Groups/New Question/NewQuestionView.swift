//
//  NewQuestionView.swift
//  Question
//
//  Created by Jack Finnis on 06/01/2022.
//

import SwiftUI

struct NewQuestionView: View {
    @StateObject var newQuestionVM = NewQuestionVM()
    
    @Binding var loading: Bool
    @Binding var finished: Bool
    
    let username: String
    
    let formatting = FormattingHelper()
    
    var body: some View {
        Section {
            NavigationLink {
                SelectQuestionView(selectedQuestion: $newQuestionVM.selectedRecentQuestion, questions: newQuestionVM.questions)
            } label: {
                HStack {
                    TextField("Enter Question", text: $newQuestionVM.newQuestion)
                        .submitLabel(.go)
                    Text("Recent")
                }
            }
            
            Toggle("Timed Question", isOn: $newQuestionVM.timedQuestion.animation())
            if newQuestionVM.timedQuestion {
                Stepper(formatting.singularPlural(singularWord: "Minute", count: newQuestionVM.newQuestionMinutes), value: $newQuestionVM.newQuestionMinutes, in: 1...60)
            }
            
            Button("Start") {
                startQuestion()
            }
        } header: {
            Text("Start a Question")
        } footer: {
            Text(newQuestionVM.newQuestionError ?? "")
        }
        .headerProminence(.increased)
        .onSubmit {
            startQuestion()
        }
        .onAppear {
            newQuestionVM.addQuestionsListener(username: username)
        }
        .onDisappear {
            newQuestionVM.removeListeners()
        }
    }
    
    func startQuestion() {
        Task {
            loading = true
            finished = await newQuestionVM.startQuestion(username: username)
            loading = false
        }
    }
}
