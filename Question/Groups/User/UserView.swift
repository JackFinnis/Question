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
                        
                        NewQuestion(loading: $userVM.loading, finished: $userVM.showMyRoomView, username: username, showRecentQuestions: true, questionID: nil, placeholderQuestion: "")
                            .sheet(isPresented: $userVM.showMyRoomView) {
                                MyRoomView(username: username)
                            }
                        
                        NavigationLink {
                            AnswersView(userVM: userVM, username: username)
                        } label: {
                            Row(leading: "My Answers", trailing: String(userVM.user!.answerIDs.count))
                        }
                    }
                }
            }
            .navigationTitle(username)
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
