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
                                    #if !os(macOS)
                                    .textInputAutocapitalization(.words)
                                    #endif
                                    .disableAutocorrection(true)
                                    .focused($joinRoomFocused)
                                    .submitLabel(.join)
                                    .onSubmit {
                                        Task {
                                            await userVM.submitJoinUser(username: username, usernamesBlockedYou: userVM.user!.usernamesBlockedYou)
                                        }
                                    }
                                Button("Join") {
                                    Task {
                                        await userVM.submitJoinUser(username: username, usernamesBlockedYou: userVM.user!.usernamesBlockedYou)
                                    }
                                }
                            } header: {
                                HStack {
                                    Text("Join a Room")
                                    Spacer()
                                    if !userVM.recentUsernames.isEmpty {
                                        Menu {
                                            ForEach(userVM.recentUsernames, id: \.self) { username in
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
                        }
                        .frame(maxWidth: 700)
                        DismissButton(focused1: _joinRoomFocused, focused2: _newQuestionFocused)
                    }
                }
            }
            .navigationTitle(username)
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .onAppear {
                userVM.addListeners(username: username)
            }
            .onDisappear {
                userVM.removeListeners()
            }
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    if userVM.loading && userVM.user != nil {
                        ProgressView()
                    }
                }
                ToolbarItem(placement: .principal) {
                    if let user = userVM.user {
                        RoomStatusButton(user: user, username: username)
                    }
                }
            }
        }
        #if os(macOS)
        .sheet(isPresented: $userVM.showMyQuestionView) {
            if let questionID = userVM.user?.liveQuestionID {
                MyQuestionView(user: userVM.user!, username: username, questionID: questionID)
            }
        }
        .sheet(isPresented: $userVM.showRoomView) {
            if let joinUsername = userVM.user?.liveJoinUsername {
                RoomView(username: username, joinUsername: joinUsername)
            }
        }
        #else
        .fullScreenCover(isPresented: $userVM.showMyQuestionView) {
            if let questionID = userVM.user?.liveQuestionID {
                MyQuestionView(user: userVM.user!, username: username, questionID: questionID)
            }
        }
        .fullScreenCover(isPresented: $userVM.showRoomView) {
            if let joinUsername = userVM.user?.liveJoinUsername {
                RoomView(username: username, joinUsername: joinUsername)
            }
        }
        #endif
    }
}
