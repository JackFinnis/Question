//
//  QuestionView.swift
//  Question
//
//  Created by Jack Finnis on 23/10/2021.
//

import SwiftUI

struct QuestionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var questionVM = QuestionVM()
    
    let username: String
    let questionID: String
    let joinUsername: String
    
    let formatting = FormattingHelper()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Group {
            if questionVM.question == nil {
                ProgressView("Loading question...")
            } else {
                VStack {
                    Text(questionVM.question!.question ?? "No Question")
                    Form {
                        Section {
                            if questionVM.isLive {
                                TextEditor(text: $questionVM.answer)
                            } else if questionVM.answer.isEmpty {
                                Text("No Answer")
                            } else {
                                Text(questionVM.answer)
                                    .contextMenu {
                                        CopyButton(string: questionVM.answer)
                                    }
                            }
                        } footer: {
                            Text(questionVM.answerError ?? "")
                        }
                        
                        Section {
                            if questionVM.answer.isEmpty {
                                HStack {
                                    Spacer()
                                    Text("No Answer")
                                    Spacer()
                                }
                            } else if questionVM.loading {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                            } else if !questionVM.unsavedChanges {
                                HStack {
                                    Spacer()
                                    Text("Submitted")
                                    Spacer()
                                }
                            } else {
                                HStack {
                                    Spacer()
                                    Button {
                                        Task {
                                            await questionVM.submitAnswer(questionID: questionID, username: username, joinUsername: joinUsername)
                                        }
                                    } label: {
                                        if questionVM.oldAnswer.isEmpty {
                                            Text("Submit")
                                        } else {
                                            Text("Resubmit")
                                        }
                                    }
                                    Spacer()
                                }
                                .foregroundColor(.white)
                                .listRowBackground(Color.accentColor)
                            }
                        }
                        
                        Section {
                            List(questionVM.answers.filter { questionVM.question!.sharedAnswerIDs.contains($0.id) }) { answer in
                                AnswerUserRow(answer: answer)
                            }
                        } header: {
                            Text(formatting.singularPlural(singularWord: "Shared Answer", count: questionVM.question!.sharedAnswerIDs.count))
                        }
                        .headerProminence(.increased)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Text(questionVM.formattedTimeRemaining)
                            .onReceive(timer) { _ in
                                questionVM.timeIntervalRemaining = questionVM.question?.end?.timeIntervalSinceNow ?? 0
                            }
                    }
                }
            }
        }
        .navigationTitle(joinUsername)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            questionVM.addListeners(questionID: questionID, username: username)
        }
        .onDisappear {
            questionVM.removeListeners()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Leave Room") {
                    dismiss()
                }
            }
        }
    }
}
