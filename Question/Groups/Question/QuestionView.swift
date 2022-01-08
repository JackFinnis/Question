//
//  QuestionView.swift
//  Question
//
//  Created by Jack Finnis on 23/10/2021.
//

import SwiftUI

struct QuestionView: View {
    @StateObject var questionVM = QuestionVM()
    
    let username: String
    let questionID: String
    
    var body: some View {
        Group {
            if questionVM.question == nil {
                ProgressView("Loading question...")
            } else if questionVM.question!.finished {
                if questionVM.question!.sharedAnswerID == nil {
                    ProgressView("Waiting for results...")
                } else {
                    AnswerView(username: username, answerID: questionVM.question!.sharedAnswerID!)
                }
            } else {
                Form {
                    Section {
                        Text(questionVM.question!.question ?? "No Question")
                    } header: {
                        Text("Question")
                    }
                    .headerProminence(.increased)
                    
                    Section {
                        TextEditor(text: $questionVM.answer)
                    } header: {
                        Text("Answer")
                    } footer: {
                        Text(questionVM.answerError ?? "")
                    }
                    .headerProminence(.increased)
                    
                    Section {
                        HStack {
                            Spacer()
                            Button {
                                Task {
                                    await questionVM.submitAnswer()
                                }
                            } label: {
                                if questionVM.oldAnswer.isEmpty {
                                    Text("Submit")
                                } else if questionVM.unsavedChanges {
                                    Text("Submit Again")
                                } else {
                                    Text("Submitted")
                                }
                            }
                            .disabled(!questionVM.unsavedChanges)
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .listRowBackground(Color.accentColor)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Countdown(question: questionVM.question!)
                    }
                }
            }
        }
        .onAppear {
            questionVM.addQuestionListener(questionID: questionID)
        }
        .onDisappear {
            questionVM.removeListeners()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                if questionVM.loading {
                    ProgressView()
                }
            }
        }
    }
}
