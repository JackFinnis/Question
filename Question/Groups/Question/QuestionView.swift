//
//  QuestionView.swift
//  Question
//
//  Created by Jack Finnis on 23/10/2021.
//

import SwiftUI

struct QuestionView: View {
    @StateObject var questionVM = QuestionVM()
    @FocusState var focused: Bool
    
    let username: String
    let questionID: String
    let joinUsername: String
    
    let formatting = FormattingHelper()
    
    var body: some View {
        Group {
            if questionVM.question == nil {
                ProgressView("Loading question...")
            } else {
                ZStack {
                    Form {}
                    VStack {
                        Text(questionVM.question!.question ?? "No Question")
                        Form {
                            Section {
                                if questionVM.isLive {
                                    TextEditor(text: $questionVM.answer)
                                        .focused($focused)
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
                                    Text("No Answer")
                                        .centred()
                                } else if questionVM.loading {
                                    ProgressView()
                                        .centred()
                                } else if !questionVM.unsavedChanges {
                                    Text("Submitted")
                                        .centred()
                                } else {
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
                                    .centred()
                                    .foregroundColor(.white)
                                    .listRowBackground(Color.accentColor)
                                }
                            }
                            
                            if !questionVM.question!.sharedAnswerIDs.isEmpty {
                                Section {
                                    List(questionVM.answers.filter { questionVM.question!.sharedAnswerIDs.contains($0.id) }) { answer in
                                        AnswerUserRow(answer: answer)
                                    }
                                    .animation(.default, value: questionVM.answers)
                                } header: {
                                    Text(formatting.singularPlural(singularWord: "Shared Answer", count: questionVM.question!.sharedAnswerIDs.count))
                                }
                                .headerProminence(.increased)
                            }
                        }
                    }
                    .frame(maxWidth: 700)
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
                    Task {
                        await questionVM.helper.leaveLiveRoom(username: username)
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Countdown(questionVM: questionVM)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focused = false
                }
            }
        }
    }
}
