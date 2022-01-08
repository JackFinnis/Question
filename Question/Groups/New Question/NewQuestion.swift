//
//  NewQuestion.swift
//  Question
//
//  Created by Jack Finnis on 06/01/2022.
//

import SwiftUI

struct NewQuestion: View {
    @StateObject var newQuestionVM = NewQuestionVM()
    
    @Binding var loading: Bool
    @Binding var finished: Bool
    
    let username: String
    let showRecentQuestions: Bool
    
    let formatting = FormattingHelper()
    
    var body: some View {
        Group {
            Section {
                NavigationLink {
                    SelectQuestionView(selectedQuestion: $newQuestionVM.selectedRecentQuestion, questions: newQuestionVM.questions)
                } label: {
                    HStack {
                        TextEditor(text: $newQuestionVM.newQuestion)
                        Text("Recent")
                            .foregroundColor(.secondary)
                    }
                }
                
                Toggle("Time Limit", isOn: $newQuestionVM.timedQuestion.animation())
                if newQuestionVM.timedQuestion {
                    Stepper(formatting.singularPlural(singularWord: "Minute", count: newQuestionVM.newQuestionMinutes), value: $newQuestionVM.newQuestionMinutes, in: 1...60)
                }
                
                Button("Start") {
                    Task {
                        loading = true
                        finished = await newQuestionVM.startQuestion(username: username)
                        loading = false
                    }
                }
            } header: {
                Text("Start a Question")
            } footer: {
                Text(newQuestionVM.newQuestionError ?? "")
            }
            .headerProminence(.increased)
            
            if showRecentQuestions {
                Section {
                    NavigationLink {
                        QuestionsView(newQuestionVM: newQuestionVM, username: username)
                    } label: {
                        Row(leading: "My Questions", trailing: String(newQuestionVM.questions.count))
                    }
                } header: {
                    Text("History")
                }
                .headerProminence(.increased)
            }
        }
        .onAppear {
            newQuestionVM.addQuestionsListener(username: username)
        }
        .onDisappear {
            newQuestionVM.removeListeners()
        }
    }
}
