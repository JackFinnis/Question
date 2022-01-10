//
//  AuthVM.swift
//  Question
//
//  Created by Jack Finnis on 05/01/2022.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthVM: ObservableObject {
    // MARK: - Properties
    @Published var username: String? = UserDefaults.standard.string(forKey: "username")
    @Published var loading = false
    @Published var signedIn = false
    
    @Published var createUsername: String = ""
    @Published var createUsernameError: String?
    
    let helper = FirebaseHelper()
    let haptics = HapticsHelper()
    let auth = Auth.auth()
    
    // MARK: - Initialisers
    init() {
        Task {
            await signIn()
        }
    }
    
    // MARK: - Methods
    func createAccount() async {
        createUsernameError = nil
        loading = true
        // Validate username
        if createUsername.isEmpty {
            createUsernameError = "Please enter a username."
        } else if createUsername.contains("/") {
            createUsernameError = "Username connot contain a forward slash."
        } else if createUsername.contains(".") {
            createUsernameError = "Username connot contain a full stop."
        } else if createUsername.contains("__.*__") {
            createUsernameError = "Username connot contain the phrase __.*__"
        } else if createUsername.count > 20 {
            createUsernameError = "Username must be shorter that 20 characters."
        } else if await helper.isInUse(username: createUsername) {
            createUsernameError = "Username is already taken."
        } else {
            await helper.addDocument(collection: "users", documentID: createUsername)
            username = createUsername
            UserDefaults.standard.set(username, forKey: "username")
            haptics.success()
            loading = false
            return
        }
        haptics.error()
        loading = false
    }
    
    func signIn() async {
        loading = true
        do {
            try await auth.signInAnonymously()
            signedIn = true
        } catch {
            createUsernameError = error.localizedDescription
            haptics.error()
        }
        loading = false
    }
}
