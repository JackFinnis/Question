//
//  MyQuestionView.swift
//  Question
//
//  Created by Jack Finnis on 24/10/2021.
//

import SwiftUI

struct MyQuestionView: View {
    @StateObject var questionVM = QuestionVM()
    @FocusState var focused: Bool
    @State var showEndAlert = false
    
    @State var redundantFinished = false
    
    let user: User
    let username: String
    let questionID: String
    
    let formatting = FormattingHelper()
    
    var body: some View {
        NavigationView {
            Group {
                if questionVM.question == nil {
                    ProgressView("Loading question...")
                } else {
                    ZStack {
                        Form {}
                        VStack {
                            Text(questionVM.question?.question ?? "No Question")
                            Form {
                                Section {
                                    TextEditor(text: $questionVM.newQuestion)
                                        .focused($focused)
                                    Button("Edit") {
                                        Task {
                                            await questionVM.submitNewQuestion(questionID: questionID)
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
                                    Button("Submit") {
                                        Task {
                                            await questionVM.submitNewTimeLimit(questionID: questionID)
                                        }
                                    }
                                } header: {
                                    Text("New Time Limit")
                                }
                                .headerProminence(.increased)
                                
                                Section {
                                    List(questionVM.answers) { answer in
                                        HStack {
                                            AnswerUserRow(answer: answer)
                                            Spacer()
                                            ToggleShareButton(questionVM: questionVM, question: questionVM.question!, answerID: answer.id)
                                        }
                                        .swipeActions {
                                            ToggleShareButton(questionVM: questionVM, question: questionVM.question!, answerID: answer.id)
                                        }
                                    }
                                    .animation(.default, value: questionVM.answers)
                                } header: {
                                    HStack {
                                        Text(formatting.singularPlural(singularWord: "Answer", count: questionVM.question!.answerIDs.count))
                                        Spacer()
                                        if !questionVM.question!.answerIDs.isEmpty {
                                            Button("Share All") {
                                                Task {
                                                    await questionVM.shareAllAnswers(question: questionVM.question!)
                                                }
                                            }
                                            .font(.none)
                                        }
                                    }
                                }
                                .headerProminence(.increased)
                            }
                            .frame(maxWidth: 700)
                        }
                        DismissButton(focused1: _focused)
                    }
                }
            }
            .navigationTitle(username)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                questionVM.addListeners(questionID: questionID, username: username)
                questionVM.startTimer()
            }
            .onDisappear {
                questionVM.removeListeners()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if questionVM.loading {
                        ProgressView()
                    } else if questionVM.isLive {
                        Button("End Now") {
                            Task {
                                await questionVM.stopQuestion(username: username, questionID: questionID)
                            }
                        }
                        .tint(.red)
                    } else {
                        Button("New Question") {
                            Task {
                                await questionVM.stopLiveQuestion(username: username)
                            }
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    RoomStatusButton(user: user, username: username)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Countdown(questionVM: questionVM)
                }
            }
        }
    }
}
