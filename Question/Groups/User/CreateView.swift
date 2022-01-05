//
//  CreateView.swift
//  Question
//
//  Created by Jack Finnis on 05/01/2022.
//

import SwiftUI

struct CreateView: View {
    @FocusState var focusedField: Field?
    
    var body: some View {
        Form {
            Section {
                TextField("Enter Username", text: $vm.inputJoinUsername)
                    .focused($focusedField, equals: .username)
                    .disableAutocorrection(true)
                    .textContentType(.username)
                    .submitLabel(.join)
                
                Button("Join") {
                    Task {
                        await vm.submitJoinUser()
                    }
                }
            } header: {
                Text("Join a Room")
            } footer: {
                Text(vm.joinUserError ?? "")
            }
            .headerProminence(.increased)
            
            Section {
                TextEditor(text: $vm.newQuestion)
                    .focused($focusedField, equals: .question)
                    .submitLabel(.go)
                
                Button("Start") {
                    Task {
                        await vm.startQuestion(username: username)
                    }
                }
            } header: {
                Text("Start a Question")
            } footer: {
                Text(vm.newQuestionError ?? "")
            }
            .headerProminence(.increased)
        }
        .onSubmit {
            Task {
                if focusedField == .username {
                    await vm.submitJoinUser()
                } else {
                    await vm.startQuestion(username: username)
                }
            }
        }
    }
}
