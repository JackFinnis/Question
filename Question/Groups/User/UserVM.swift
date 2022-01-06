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
    
    @Published var joinUsername = ""
    @Published var joinUsernameError: String?
    
    @Published var newQuestion = ""
    @Published var newQuestionMinutes: Double?
    @Published var newQuestionError: String?
    
    @Published var showRoomView = false
    @Published var showMyRoomView = false
    
    let helper = FirebaseHelper()
    
    var userListener: ListenerRegistration?
    
    // MARK: - Listeners
    func addUserListener(username: String) {
        loading = true
        userListener?.remove()
        userListener = helper.addUserListener(userID: username) { user in
            self.user = user
            self.loading = false
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
    
    func startQuestion(username: String) async {
        newQuestionError = nil
        if newQuestion.isEmpty {
            newQuestionError = "Please enter a question"
        } else {
            loading = true
            let newQuestionID = helper.getUniqueID()
            var endDate: Date?
            if newQuestionMinutes != nil {
                endDate = Date().addingTimeInterval(newQuestionMinutes! * 60)
            }
            
            await helper.addDocument(collection: "questions", documentID: newQuestionID, data: [
                "end": endDate as Any,
                "askerUsername": username,
                "question": newQuestion
            ])
            await helper.updateData(collection: "users", documentID: username, data: [
                "liveQuestion": newQuestionID
            ])
            await helper.addElement(collection: "users", documentID: username, arrayName: "questionIDs", element: newQuestionID)
            
            loading = false
            showMyRoomView = true
        }
    }
}
