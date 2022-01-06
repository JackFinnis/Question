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
    
    var body: some View {
        NavigationView {
            Group {
                if userVM.user == nil {
                    ProgressView("Loading profile...")
                } else {
                    Form {
                        CreateGroup(userVM: userVM, username: username)
                        
                        Section {
                            //todo
                        } header: {
                            Row(leading: "Your Questions", trailing: String(userVM.user!.questionIDs.count))
                        }
                        .headerProminence(.increased)
                        
                        Section {
                            //todo
                        } header: {
                            Row(leading: "Your Answers", trailing: String(userVM.user!.answerIDs.count))
                        }
                        .headerProminence(.increased)
                    }
                }
            }
            .navigationTitle(username)
            .onAppear {
                userVM.addUserListener(username: username)
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
