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
                        
                        NewQuestion(loading: $userVM.loading, finished: $userVM.showMyRoomView, username: username, showRecentQuestions: true)
                            .sheet(isPresented: $userVM.showMyRoomView) {
                                MyRoomView(username: username)
                            }
                        
                        Section {
                            List(userVM.answers) { answer in
                                AnswerRow(username: username, answer: answer)
                            }
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
