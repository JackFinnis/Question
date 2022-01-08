//
//  NewQuestionVM.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import Foundation
import FirebaseFirestore

@MainActor
class NewQuestionVM: ObservableObject {
    // MARK: - Properties
    @Published var questions = [Question]()
    @Published var selectedRecentQuestion: Question? { didSet {
        newQuestion = selectedRecentQuestion?.question ?? newQuestion
        if let minutes = selectedRecentQuestion?.minutes {
            newQuestionMinutes = minutes
            timedQuestion = true
        } else {
            timedQuestion = false
        }
    }}
    
    @Published var loading = false
    @Published var finished = false
    
    @Published var newQuestion = ""
    @Published var newQuestionError: String?
    
    @Published var timedQuestion = false
    @Published var newQuestionMinutes: Int = 2
    
    let helper = FirebaseHelper()
    
    var questionsListener: ListenerRegistration?
    
    // MARK: - Listeners
    func addQuestionsListener(username: String) {
        questionsListener?.remove()
        questionsListener = helper.addCollectionListener(collection: "questions", field: "askerUsername", isEqualTo: username) { documents in
            self.questions = documents.map { document -> Question in
                Question(id: document.documentID, data: document.data())
            }
        }
    }
    
    func removeListeners() {
        questionsListener?.remove()
    }
    
    // MARK: - Methods
    func startQuestion(username: String) async -> Bool {
        newQuestionError = nil
        if newQuestion.isEmpty {
            newQuestionError = "Please enter a question"
            return false
        } else {
            loading = true
            let newQuestionID = helper.getUniqueID()
            var endDate: Date?
            if timedQuestion {
                endDate = Date().addingTimeInterval(Double(newQuestionMinutes * 60))
            }
            
            await helper.addDocument(collection: "questions", documentID: newQuestionID, data: [
                "end": endDate as Any,
                "askerUsername": username,
                "question": newQuestion,
                "minutes": timedQuestion ? newQuestionMinutes : helper.nothing as Any
            ])
            await helper.updateData(collection: "users", documentID: username, data: [
                "liveQuestion": newQuestionID
            ])
            await helper.addElement(collection: "users", documentID: username, arrayName: "questionIDs", element: newQuestionID)
            
            loading = false
            return true
        }
    }
}
