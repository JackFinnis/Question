//
//  UserView.swift
//  Question
//
//  Created by Jack Finnis on 23/10/2021.
//

import SwiftUI

struct UserView: View {
    @StateObject var userVM = UserVM()
    
    let username: String
    let formatting = FormattingHelper()
    
    var body: some View {
        NavigationView {
            Group {
                if userVM.user == nil {
                    ProgressView("Loading profile...")
                } else {
                    Form {
                        Section {
                            HStack {
                                TextField("Enter Username", text: $userVM.joinUsername)
                                    .disableAutocorrection(true)
                                    .textContentType(.username)
                                    .submitLabel(.join)
                                if !userVM.recentUsernames.isEmpty {
                                    Picker("", selection: $userVM.joinUsername) {
                                        ForEach(userVM.recentUsernames, id: \.self) { username in
                                            Text(username)
                                        }
                                    }
                                }
                            }
                            
                            Button("Join") {
                                Task {
                                    await userVM.submitJoinUser()
                                }
                            }
                        } header: {
                            Text("Join a Room")
                        } footer: {
                            Text(userVM.joinUsernameError ?? "")
                        }
                        .headerProminence(.increased)
                        .onSubmit {
                            Task {
                                await userVM.submitJoinUser()
                            }
                        }
                        .sheet(isPresented: $userVM.showRoomView) {
                            RoomView(username: username, joinUsername: userVM.joinUsername)
                        }
                        
                        NewQuestionView(loading: $userVM.loading, finished: $userVM.showMyRoomView, username: username)
                            .sheet(isPresented: $userVM.showMyRoomView) {
                                MyRoomView(username: username)
                            }
                        
                        Section {
                            //todo
                        } header: {
                            Text(formatting.singularPlural(singularWord: "Question", count: userVM.user!.questionIDs.count))
                        }
                        .headerProminence(.increased)
                        
                        Section {
                            //todo
                        } header: {
                            Text(formatting.singularPlural(singularWord: "Answer", count: userVM.user!.answerIDs.count))
                        }
                        .headerProminence(.increased)
                    }
                }
            }
            .navigationTitle(username)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                userVM.addListeners(username: username)
            }
            .onDisappear {
                userVM.removeListeners()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if userVM.loading {
                        ProgressView()
                    }
                }
            }
        }
    }
}
