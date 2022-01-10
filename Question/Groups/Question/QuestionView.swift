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
                            
                            if !questionVM.filteredSharedAnswers.isEmpty {
                                Section {
                                    List(questionVM.filteredSharedAnswers) { answer in
                                        AnswerUserRow(answer: answer)
                                    }
                                    .animation(.default, value: questionVM.answers)
                                } header: {
                                    Text(formatting.singularPlural(singularWord: "Shared Answer", count: questionVM.filteredSharedAnswers.count))
                                }
                                .headerProminence(.increased)
                            }
                        }
                        .frame(maxWidth: 700)
                    }
                    DismissButton(focused1: _focused)
                }
            }
        }
        .navigationTitle(joinUsername)
        #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            questionVM.addListeners(questionID: questionID, username: username)
            questionVM.startTimer()
        }
        .onDisappear {
            questionVM.removeListeners()
        }
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button("Leave Room") {
                    Task {
                        await questionVM.helper.leaveLiveRoom(username: username)
                    }
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Countdown(questionVM: questionVM)
            }
        }
    }
}
