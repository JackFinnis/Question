//
//  NewQuestion.swift
//  Question
//
//  Created by Jack Finnis on 06/01/2022.
//

import SwiftUI

struct NewQuestion: View {
    @ObservedObject var userVM: UserVM
    
    let username: String
    
    let formatting = FormattingHelper()
    
    var body: some View {
        Section {
            NavigationLink {
                SelectQuestionView(selectedQuestion: $userVM.selectedRecentQuestion, questions: userVM.questions)
            } label: {
                HStack {
                    TextEditor(text: $userVM.newQuestion)
                    Text("Recent")
                        .foregroundColor(.secondary)
                }
            }
            
            Toggle("Time Limit", isOn: $userVM.timedQuestion.animation())
            if userVM.timedQuestion {
                Stepper(formatting.singularPlural(singularWord: "Minute", count: userVM.newQuestionMinutes), value: $userVM.newQuestionMinutes, in: 1...60)
            }
            
            Button("Start") {
                Task {
                    await userVM.startQuestion(username: username)
                }
            }
        } header: {
            Text("Start a Question")
        } footer: {
            Text(userVM.newQuestionError ?? "")
        }
        .headerProminence(.increased)
        .sheet(isPresented: $userVM.showMyRoomView) {
            MyRoomView(username: username)
        }
    }
}
