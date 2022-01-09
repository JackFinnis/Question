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
                        JoinRoom(userVM: userVM, username: username)
                        NewQuestion(userVM: userVM, username: username)
                        
//                        Section {
//                            NavigationLink {
//                                QuestionsView(userVM: userVM, user: userVM.user!, username: username)
//                            } label: {
//                                Row(leading: "My Questions", trailing: String(userVM.questions.count))
//                            }
//                            NavigationLink {
//                                AnswersView(userVM: userVM, username: username)
//                            } label: {
//                                Row(leading: "My Answers", trailing: String(userVM.answers.count))
//                            }
//                        } header: {
//                            Text("History")
//                        }
//                        .headerProminence(.increased)
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
            .onDisappear {
                userVM.removeListeners()
            }
        }
    }
}
