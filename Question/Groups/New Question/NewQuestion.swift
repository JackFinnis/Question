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
    
    let questionID: String?
    let placeholderQuestion: String
    
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
                
                Button(questionID == nil ? "Start" : "Edit") {
                    Task {
                        loading = true
                        finished = await newQuestionVM.startQuestion(username: username, questionID: questionID)
                        loading = false
                    }
                }
            } header: {
                Text(questionID == nil ? "Start a Question" : "Edit Question")
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
            newQuestionVM.newQuestion = placeholderQuestion
        }
        .onDisappear {
            newQuestionVM.removeListeners()
        }
    }
}
