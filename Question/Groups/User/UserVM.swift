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
    @Published var answers = [Answer]()
    @Published var loading = false

    @Published var showRoomView = false
    @Published var showMyRoomView = false
    
    @Published var joinUsername = ""
    @Published var joinUsernameError: String?
    
    let helper = FirebaseHelper()
    
    var userListener: ListenerRegistration?
    var answersListener: ListenerRegistration?
    
    var recentUsernames: [String] {
        let sortedAnswers = answers.sorted { $0.date > $1.date }
        var recentUsernames = [String]()
        for answer in sortedAnswers {
            if let askerUsername = answer.askerUsername {
                recentUsernames.append(askerUsername)
            }
        }
        return recentUsernames
    }
    
    // MARK: - Listeners
    func addUserListener(username: String) {
        loading = true
        userListener?.remove()
        userListener = helper.addUserListener(userID: username) { user in
            self.loading = false
            self.user = user
        }
    }
    
    func addAnswersListener(username: String) {
        answersListener?.remove()
        answersListener = helper.addCollectionListener(collection: "answers", field: "answerUsername", isEqualTo: username) { documents in
            self.answers = documents.map { document -> Answer in
                Answer(id: document.documentID, data: document.data())
            }
        }
    }
    
    func removeListeners() {
        userListener?.remove()
        answersListener?.remove()
    }
    
    func addListeners(username: String) {
        addUserListener(username: username)
        addAnswersListener(username: username)
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
