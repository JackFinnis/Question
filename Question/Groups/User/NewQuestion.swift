//
//  NewQuestion.swift
//  Question
//
//  Created by Jack Finnis on 06/01/2022.
//

import SwiftUI

struct NewQuestion: View {
    var body: some View {
        Section {
            TextField("Enter Question", text: $userVM.newQuestion)
                .focused($focusedField, equals: .question)
                .submitLabel(.go)
            
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
    }
}
