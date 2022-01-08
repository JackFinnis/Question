//
//  MyQuestionView.swift
//  Question
//
//  Created by Jack Finnis on 24/10/2021.
//

import SwiftUI

struct MyQuestionView: View {
    @StateObject var questionVM = QuestionVM()
    
    let username: String
    let questionID: String
    
    var body: some View {
        Group {
            if questionVM.question == nil {
                ProgressView("Loading question...")
            } else {
                Form {
                    Section {
                        TextField(questionVM.question!.question ?? "No Question", text: $questionVM.newQuestion)
                            .submitLabel(.go)
                        Button("Resubmit") {
                            Task {
                                await questionVM.submitNewQuestion()
                            }
                        }
                    } header: {
                        Text("Question")
                    } footer: {
                        Text(questionVM.newQuestionError ?? "")
                    }
                    .headerProminence(.increased)
                    
                    Section {
                        //todo
                    } header: {
                        Text("Answers")
                    }
                }
                .onSubmit {
                    Task {
                        await questionVM.submitNewQuestion()
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
    }
}
