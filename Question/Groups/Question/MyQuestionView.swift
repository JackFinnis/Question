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
    
    let user: User
    let username: String
    let questionID: String
    
    let formatting = FormattingHelper()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Group {
            if questionVM.question == nil {
                ProgressView("Loading question...")
            } else {
                VStack {
                    Text(questionVM.question?.question ?? "No Question")
                    Form {
                        if questionVM.isLive {
                            Section {
                                TextEditor(text: $questionVM.newQuestion)
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
                        }
                        
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
                        } header: {
                            HStack {
                                Text(formatting.singularPlural(singularWord: "Answer", count: questionVM.question!.answerIDs.count))
                                Spacer()
                                Button("Share All") {
                                    Task {
                                        await questionVM.shareAllAnswers(question: questionVM.question!)
                                    }
                                }
                                .font(.none)
                            }
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
        .navigationTitle(username)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            questionVM.addListeners(questionID: questionID, username: username)
        }
        .onDisappear {
            questionVM.removeListeners()
            Task {
                await questionVM.stopLiveQuestion(username: username)
            }
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
                    Button("Leave Room") {
                        dismiss()
                    }
                }
            }
            ToolbarItem(placement: .principal) {
                RoomStatusButton(joinUsername: username, guestUsernames: user.guestUsernames)
            }
        }
    }
}
