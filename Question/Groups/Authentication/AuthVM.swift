//
//  AuthVM.swift
//  Question
//
//  Created by Jack Finnis on 05/01/2022.
//

import Foundation

@MainActor
class AuthVM: ObservableObject {
    // MARK: - Properties
    @Published var username: String? = UserDefaults.standard.string(forKey: "username")
    @Published var loading = false
    
    @Published var createUsername: String = ""
    @Published var createUsernameError: String?
    
    let helper = FirebaseHelper()
    
    // MARK: - Methods
    func createAccount() async {
        createUsernameError = nil
        loading = true
        // Validate username
        if createUsername.isEmpty {
            createUsernameError = "Please enter a username"
        } else if await !helper.isInUse(username: createUsername) {
            await helper.addDocument(collection: "users", documentID: createUsername)
            username = createUsername
            UserDefaults.standard.set(username, forKey: "username")
        } else {
            createUsernameError = "Username is already taken"
        }
        loading = false
    }
}
