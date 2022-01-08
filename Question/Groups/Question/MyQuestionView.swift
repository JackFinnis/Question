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
                                .submitLabel(.go)
                                .onSubmit {
                                    Task {
                                        await questionVM.resubmitQuestion(questionID: questionID, username: username)
                                    }
                                }
                            Button("Resubmit") {
                                Task {
                                    await questionVM.resubmitQuestion(questionID: questionID, username: username)
                                }
                            }
                        } footer: {
                            Text(questionVM.newQuestionError ?? "")
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
                        Countdown(question: questionVM.question!)
                    }
                }
            }
        }
        .onAppear {
            questionVM.addListeners(questionID: questionID, username: username)
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
                        dismiss()
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
