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
            } else if questionVM.error {
                HStack {
                    Image(systemName: "questionmark")
                        .font(.title)
                    Text("This question has been deleted")
                }
            } else {
                VStack {
                    Text(questionVM.question!.question ?? "No Question")
                    
                    Form {
                        Section {
                            if questionVM.isLive {
                                TextEditor(text: $questionVM.answer)
                            } else {
                                Text(questionVM.answer)
                            }
                        } footer: {
                            Text(questionVM.answerError ?? "")
                        }
                        
                        Section {
                            if !questionVM.unsavedChanges {
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
                Button("Leave") {
                    dismiss()
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
