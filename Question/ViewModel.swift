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
    @Published var user: User?
    @Published var joinUsername: String? { didSet {
        UserDefaults.standard.set(joinUsername, forKey: "joinUsername")
        addJoinUserListener()
    }}
    @Published var joinUser: User?
    @Published var questionID: String?
    @Published var question: Question?
    
    // Inputs
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
        joinUsername = UserDefaults.standard.string(forKey: "joinUsername")
    }
    
    // MARK: - Listeners
    func addUserListener() {
        user = nil
        userListener?.remove()
        if username != nil {
            loading = true
            userListener = helper.addUserListener(userID: username!) { user in
                self.user = user
                self.loading = false
            }
        }
    }
    
    func addJoinUserListener() {
        joinUser = nil
        joinUserListener?.remove()
        if joinUsername != nil {
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
            self.loading = false
            if let data = data {
                self.question = Question(id: questionID, data: data)
            } else {
                self.question = nil
            }
        }
    }
    
    func removeQuestionListener() {
        questionListener?.remove()
    }
    
    // MARK: - Methods
    func submitJoinUser() async {
        loading = true
        if inputJoinUsername.isEmpty {
            joinUserError = "Please enter a username"
        } else if await helper.usernameInUse(username: inputJoinUsername) {
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
    
    func stopLiveQuestion(username: String) {
        // todo
    }
}
