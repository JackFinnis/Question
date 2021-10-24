//
//  ViewModel.swift
//  Ecommunity
//
//  Created by Jack Finnis on 22/09/2021.
//

import Foundation
import FirebaseFirestore

@MainActor
class ViewModel: ObservableObject {
    // MARK: - Properties
    // General
    @Published var loading: Bool = false
    @Published var username: String? { didSet {
        UserDefaults.standard.set(username, forKey: "username")
        addUserListener()
    }}
    @Published var user: User?
    @Published var joinUsername: String? { didSet {
        UserDefaults.standard.set(joinUsername, forKey: "joinUsername")
        addJoinUserListener()
    }}
    @Published var joinUser: User?
    @Published var questionID: String?
    @Published var question: Question?
    
    // Inputs
    @Published var createUsername: String = ""
    @Published var createUsernameError: String?
    @Published var inputJoinUsername: String = ""
    @Published var joinUserError: String?
    @Published var minutes: Double?
    @Published var newQuestion: String = ""
    @Published var newQuestionError: String?
    
    let db = Firestore.firestore()
    let helper = FirebaseHelper()
    
    var userListener: ListenerRegistration?
    var joinUserListener: ListenerRegistration?
    var questionListener: ListenerRegistration?
    
    // MARK: - Initialiser
    init() {
        username = UserDefaults.standard.string(forKey: "username")
        joinUsername = UserDefaults.standard.string(forKey: "joinUsername")
        createUsernameError = "This username cannot be changed and is public"
    }
    
    // MARK: - Listeners
    func addUserListener() {
        user = nil
        if username == nil {
            userListener?.remove()
        } else {
            loading = true
            userListener = helper.addUserListener(userID: username!) { user in
                self.user = user
                self.loading = false
            }
        }
    }
    
    func addJoinUserListener() {
        joinUser = nil
        if joinUsername == nil {
            joinUserListener?.remove()
        } else {
            loading = true
            joinUserListener = helper.addUserListener(userID: joinUsername!) { user in
                self.joinUser = user
                self.loading = false
            }
        }
    }
    
    func addQuestionListener(questionID: String) {
        question = nil
        loading = true
        questionListener = helper.addDocumentListener(collection: "questions", documentID: questionID) { data in
            self.question = Question(id: questionID, data: data)
            self.loading = false
        }
    }
    
    func removeQuestionListener() {
        questionListener?.remove()
    }
    
    // MARK: - Methods
    func createAccount() async {
        createUsernameError = nil
        loading = true
        // Validate username
        if createUsername.isEmpty {
            createUsernameError = "Please enter a username"
        } else if await !usernameInUse(username: createUsername) {
            await helper.addDocument(collection: "users", documentID: createUsername, data: [
                "username": [createUsername]
            ])
            username = createUsername
        } else {
            createUsernameError = "Username taken"
        }
        loading = false
    }
    
    func usernameInUse(username: String) async -> Bool {
        let data = await helper.getDocumentData(collection: "users", documentID: username)
        return data != nil && !data!.isEmpty
    }
    
    func submitJoinUser() async {
        loading = true
        if inputJoinUsername.isEmpty {
            joinUserError = "Please enter a username"
        } else if await usernameInUse(username: inputJoinUsername) {
            joinUsername = inputJoinUsername
        } else {
            joinUserError = "User does not exist"
        }
        loading = false
    }
    
    func startQuestion(username: String) async {
        newQuestionError = nil
        if newQuestion.isEmpty {
            newQuestionError = "Please enter a question"
        } else {
            loading = true
            let id = helper.getUniqueID()
            var endDate: Date?
            if minutes != nil {
                endDate = Date().addingTimeInterval(minutes! * 60)
            }
            
            await helper.addDocument(collection: "questions", documentID: id, data: [
                "id": [id],
                "share": false,
                "end": endDate as Any,
                "username": username,
                "question": newQuestion
            ])
            await helper.updateData(collection: "users", documentID: username, data: [
                "liveQuestion": id
            ])
            
            questionID = id
            loading = false
        }
    }
}
