//
//  UserView.swift
//  Question
//
//  Created by Jack Finnis on 23/10/2021.
//

import SwiftUI

struct UserView: View {
    @StateObject var userVM = UserVM()
    @FocusState var joinRoomFocused: Bool
    @FocusState var newQuestionFocused: Bool
    
    let username: String
    let formatting = FormattingHelper()
    
    var body: some View {
        NavigationView {
            Group {
                if userVM.user == nil {
                    ProgressView("Loading profile...")
                } else {
                    ZStack {
                        Form { }
                        Form {
                            Section {
                                TextField("Enter Username", text: $userVM.joinUsername)
                                    .disableAutocorrection(true)
                                    .focused($joinRoomFocused)
                                    .submitLabel(.join)
                                    .onSubmit {
                                        Task {
                                            await userVM.submitJoinUser(username: username)
                                        }
                                    }
                                Button("Join") {
                                    Task {
                                        await userVM.submitJoinUser(username: username)
                                    }
                                }
                            } header: {
                                HStack {
                                    Text("Join a Room")
                                    Spacer()
                                    if !userVM.recentUsernames.isEmpty {
                                        Menu {
                                            List(userVM.recentUsernames, id: \.self) { username in
                                                Button {
                                                    withAnimation {
                                                        userVM.joinUsername = username
                                                    }
                                                } label: {
                                                    Text(username)
                                                }
                                            }
                                        } label: {
                                            Text("Recent")
                                        }
                                        .font(.none)
                                    }
                                }
                            } footer: {
                                Text(userVM.joinUsernameError ?? "")
                            }
                            .headerProminence(.increased)
                            .fullScreenCover(isPresented: $userVM.showRoomView) {
                                if let joinUsername = userVM.user?.liveJoinUsername {
                                    RoomView(username: username, joinUsername: joinUsername)
                                }
                            }
                            
                            Section {
                                TextEditor(text: $userVM.newQuestion)
                                    .focused($newQuestionFocused)
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
                            .fullScreenCover(isPresented: $userVM.showMyQuestionView) {
                                if let questionID = userVM.user?.liveQuestionID {
                                    MyQuestionView(user: userVM.user!, username: username, questionID: questionID)
                                }
                            }
                        }
                        .frame(maxWidth: 700)
                    }
                }
            }
            .navigationTitle(username)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                userVM.addListeners(username: username)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if userVM.loading {
                        ProgressView()
                    }
                }
                ToolbarItem(placement: .principal) {
                    if let user = userVM.user {
                        RoomStatusButton(user: user, username: username)
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        joinRoomFocused = false
                        newQuestionFocused = false
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
