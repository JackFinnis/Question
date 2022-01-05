//
//  UserView.swift
//  Question
//
//  Created by Jack Finnis on 23/10/2021.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var vm: ViewModel
    @FocusState var focusedField: Field?
    
    let username: String
    
    var body: some View {
        Group {
            if vm.user == nil {
                ProgressView("Loading profile...")
            } else if vm.user!.liveQuestionID != nil {
                MyQuestionView(username: username, questionID: vm.user!.liveQuestionID!)
            } else {
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
        .navigationTitle(username)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if vm.loading {
                    ProgressView()
                }
            }
        }
    }
}
