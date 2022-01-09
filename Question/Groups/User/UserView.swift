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
                    ZStack {
                        Form { }
                        Form {
                            Section {
                                TextField("Enter Username", text: $userVM.joinUsername)
                                    .disableAutocorrection(true)
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
                                                    userVM.joinUsername = username
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
                                RoomView(username: username, joinUsername: userVM.joinUsername)
                            }
                            
                            Section {
                                TextEditor(text: $userVM.newQuestion)
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
                            .fullScreenCover(isPresented: $userVM.showMyRoomView) {
                                if let questionID = userVM.newQuestionID {
                                    MyQuestionView(user: userVM.user!, username: username, questionID: questionID)
                                }
                            }
                        }
                        .frame(maxWidth: 700)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            if userVM.loading {
                                ProgressView()
                            }
                        }
                        ToolbarItem(placement: .principal) {
                            RoomStatusButton(joinUsername: username, guestUsernames: userVM.user!.guestUsernames)
                        }
                    }
                }
            }
            .navigationTitle(username)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                userVM.addListeners(username: username)
            }
        }
        .navigationViewStyle(.stack)
    }
}
