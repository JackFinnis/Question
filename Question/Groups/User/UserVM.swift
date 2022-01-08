//
//  UserVM.swift
//  Question
//
//  Created by Jack Finnis on 05/01/2022.
//

import Foundation
import FirebaseFirestore

@MainActor
class UserVM: ObservableObject {
    // MARK: - Properties
    @Published var user: User?
    @Published var loading = false
    
    @Published var showRoomView = false
    @Published var showMyRoomView = false
    
    @Published var joinUsername = ""
    @Published var joinUsernameError: String?
    
    let helper = FirebaseHelper()
    
    var userListener: ListenerRegistration?
    
    // MARK: - Listeners
    func addUserListener(username: String) {
        loading = true
        userListener?.remove()
        userListener = helper.addUserListener(userID: username) { user in
            self.loading = true
            self.user = user
        }
    }
    
    func removeListeners() {
        userListener?.remove()
    }
    
    // MARK: - Methods
    func submitJoinUser() async {
        loading = true
        joinUsernameError = nil
        if joinUsername.isEmpty {
            joinUsernameError = "Please enter a username"
        } else if await helper.isInUse(username: joinUsername) {
            showRoomView = true
        } else {
            joinUsernameError = "User does not exist"
        }
        loading = false
    }
}
