//
//  RootView.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import SwiftUI

struct RootView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var authVM = AuthVM()
    
    let helper = FirebaseHelper()
    
    var body: some View {
        Group {
            if authVM.username == nil {
                SignUpView(authVM: authVM)
            } else if !authVM.signedIn {
                ProgressView("Signing in...")
            } else {
                UserView(username: authVM.username!)
                    .onChange(of: scenePhase) { newPhase in
                        Task {
                            if newPhase == .active {
                                await helper.joinRoom(username: authVM.username!)
                            } else {
                                await helper.leaveRoom(username: authVM.username!)
                            }
                        }
                    }
            }
        }
        .navigationViewStyle(.stack)
    }
}
