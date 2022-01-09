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
                            JoinRoom(userVM: userVM, username: username)
                            NewQuestion(userVM: userVM, username: username)
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
            .onDisappear {
                userVM.removeListeners()
            }
        }
        .navigationViewStyle(.stack)
    }
}
