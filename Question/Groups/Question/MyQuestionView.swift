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
                                await questionVM.resubmitQuestion()
                            }
                        }
                    } header: {
                        Text("Question")
                    } footer: {
                        Text(questionVM.newQuestionError ?? "")
                    }
                    .headerProminence(.increased)
                    
                    Section {
                        List(questionVM.answers) { answer in
                            HStack {
                                AnswerRow(answer: answer)
                                ToggleShareButton(questionVM: questionVM, question: questionVM.question!, answerID: answer.id)
                            }
                            .swipeActions {
                                ToggleShareButton(questionVM: questionVM, question: questionVM.question!, answerID: answer.id)
                            }
                        }
                    } header: {
                        Text("Answers")
                    }
                }
                .onSubmit {
                    Task {
                        await questionVM.resubmitQuestion()
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
            questionVM.addListeners(questionID: questionID)
        }
        .onDisappear {
            questionVM.removeListeners()
        }
        .interactiveDismissDisabled()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Stop Question") {
                    Task {
                        await questionVM.stopQuestion(username: username)
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
