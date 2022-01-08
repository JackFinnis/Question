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
    
    @Published var filteredQuestions = [Question]()
    @Published var searchText = "" { didSet {
        filterQuestions()
    }}
    
    let helper = FirebaseHelper()
    
    var questionsListener: ListenerRegistration?
    
    // MARK: - Listeners
    func addQuestionsListener(username: String) {
        questionsListener?.remove()
        questionsListener = helper.addCollectionListener(collection: "questions", field: "askerUsername", isEqualTo: username) { documents in
            self.questions = documents.map { document -> Question in
                Question(id: document.documentID, data: document.data())
            }.sorted { $0.end ?? Date() > $1.end ?? Date() }
            self.filterQuestions()
        }
    }
    
    func removeListeners() {
        questionsListener?.remove()
    }
    
    // MARK: - Methods
    func filterQuestions() {
        if searchText.isEmpty {
            filteredQuestions = questions
        } else {
            filteredQuestions = questions.filter {
                $0.question?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }
    
    func startQuestion(username: String, questionID: String?) async -> Bool {
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
            
            if let questionID = questionID {
                await helper.updateData(collection: "questions", documentID: questionID, data: [
                    "end": endDate as Any,
                    "question": newQuestion,
                    "minutes": timedQuestion ? newQuestionMinutes : helper.nothing as Any
                ])
            } else {
                await helper.addDocument(collection: "questions", documentID: newQuestionID, data: [
                    "end": endDate as Any,
                    "askerUsername": username,
                    "question": newQuestion,
                    "minutes": timedQuestion ? newQuestionMinutes : helper.nothing as Any
                ])
                await helper.updateData(collection: "users", documentID: username, data: [
                    "liveQuestionID": newQuestionID
                ])
                await helper.addElement(collection: "users", documentID: username, arrayName: "questionIDs", element: newQuestionID)
            }
            
            loading = false
            return true
        }
    }
}
