//
//  MyQuestionView.swift
//  Question
//
//  Created by Jack Finnis on 24/10/2021.
//

import SwiftUI

struct MyQuestionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var questionVM = QuestionVM()
    @State var redundantFinished = false
    @State var showEndAlert = false
    
    let username: String
    let questionID: String
    
    let formatting = FormattingHelper()
    
    var body: some View {
        Group {
            if questionVM.question == nil {
                ProgressView("Loading question...")
            } else {
                VStack {
                    Text(questionVM.question?.question ?? "No Question")
                    Form {
                        Section {
                            TextEditor(text: $questionVM.newQuestion)
                            Button("Edit") {
                                Task {
                                    await questionVM.submitNewQuestion(username: username)
                                }
                            }
                        } header: {
                            Text("Edit Question")
                        } footer: {
                            Text(questionVM.newQuestionError ?? "")
                        }
                        .headerProminence(.increased)
                        
                        Section {
                            Toggle("Time Limit", isOn: $questionVM.newTimedQuestion.animation())
                            if questionVM.newTimedQuestion {
                                Stepper(formatting.singularPlural(singularWord: "Minute", count: questionVM.newQuestionMinutes), value: $questionVM.newQuestionMinutes, in: 1...60)
                            }
                            Button("Edit") {
                                Task {
                                    await questionVM.submitNewTimeLimit(username: username)
                                }
                            }
                        } header: {
                            Text("Edit Time Limit")
                        }
                        .headerProminence(.increased)
                        
                        Section {
                            List(questionVM.answers) { answer in
                                HStack {
                                    AnswerUserRow(answer: answer)
                                    ToggleShareButton(questionVM: questionVM, question: questionVM.question!, answerID: answer.id)
                                }
                                .swipeActions {
                                    ToggleShareButton(questionVM: questionVM, question: questionVM.question!, answerID: answer.id)
                                }
                            }
                        } header: {
                            Text(formatting.singularPlural(singularWord: "Answer", count: questionVM.question!.sharedAnswerIDs.count))
                        }
                        .headerProminence(.increased)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Countdown(timeIntervalRemaining: questionVM.question?.end?.timeIntervalSinceNow ?? 0, question: questionVM.question!)
                    }
                }
            }
        }
        .navigationTitle(username)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            questionVM.addListeners(questionID: questionID, username: username)
        }
        .onDisappear {
            questionVM.removeListeners()
        }
        .interactiveDismissDisabled(!(questionVM.question?.finished ?? false))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if questionVM.question?.finished ?? false {
                    Button("Done") {
                        dismiss()
                    }
                } else {
                    Button("End") {
                        showEndAlert = true
                    }
                    .tint(.red)
                    .confirmationDialog("End Question?", isPresented: $showEndAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("End Question", role: .destructive) {
                            Task {
                                await questionVM.stopQuestion(username: username, questionID: questionID)
                            }
                        }
                    }
                }
            }
            ToolbarItem(placement: .principal) {
                if questionVM.loading {
                    ProgressView()
                }
            }
        }
    }
}
