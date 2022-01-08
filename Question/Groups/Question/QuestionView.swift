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
    
    let formatting = FormattingHelper()
    
    var body: some View {
        Group {
            if questionVM.question == nil {
                ProgressView("Loading question...")
            } else if questionVM.error {
                HStack {
                    Image(systemName: "questionmark")
                        .font(.title)
                    Text("This question has been deleted")
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
                            .disabled(questionVM.question!.finished)
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
                    
                    Section {
                        List(questionVM.answers.filter { questionVM.question!.sharedAnswerIDs.contains($0.id) }) { answer in
                            AnswerRow(answer: answer)
                        }
                    } header: {
                        Text(formatting.singularPlural(singularWord: "Answer", count: questionVM.question!.sharedAnswerIDs.count))
                    }
                    .headerProminence(.increased)
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                if questionVM.loading {
                    ProgressView()
                }
            }
        }
    }
}
