//
//  QuestionVM.swift
//  Question
//
//  Created by Jack Finnis on 05/01/2022.
//

import Foundation
import FirebaseFirestore

@MainActor
class QuestionVM: ObservableObject {
    // MARK: - Properties
    @Published var question: Question?
    @Published var answers = [Answer]()
    
    @Published var loading = false
    @Published var error = false
    
    @Published var answer = ""
    @Published var answerError: String?
    @Published var oldAnswer = ""
    var unsavedChanges: Bool { oldAnswer != answer }
    
    @Published var newQuestion = ""
    @Published var newQuestionError: String?
    
    let helper = FirebaseHelper()
    
    var questionListener: ListenerRegistration?
    var answersListener: ListenerRegistration?
    
    // MARK: - Listeners
    func addQuestionListener(questionID: String) {
        loading = true
        questionListener?.remove()
        questionListener = helper.addDocumentListener(collection: "questions", documentID: questionID) { data in
            self.loading = false
            if let data = data {
                self.question = Question(id: questionID, data: data)
            } else {
                self.question = nil
                self.error = true
            }
        }
    }
    
    func addAnswersListener(questionID: String) {
        answersListener?.remove()
        answersListener = helper.addCollectionListener(collection: "answers", field: "questionID", isEqualTo: questionID) { documents in
            self.answers = documents.map { document -> Answer in
                Answer(id: document.documentID, data: document.data())
            }.sorted { $0.date > $1.date }
        }
    }
    
    func removeListeners() {
        questionListener?.remove()
        answersListener?.remove()
    }
    
    func addListeners(questionID: String) {
        addQuestionListener(questionID: questionID)
        addAnswersListener(questionID: questionID)
    }
    
    // MARK: - Methods
    func submitAnswer(questionID: String, username: String, joinUsername: String) async {
        answerError = nil
        if answer.isEmpty {
            answerError = "Please enter an answer"
        } else {
            loading = true
            
            let newAnswerID = questionID + username
            await helper.addDocument(collection: "answers", documentID: newAnswerID, data: [
                "date": Date(),
                "answer": answer,
                "questionID": questionID,
                "askerUsername": joinUsername,
                "answerUsername": username
            ])
            await helper.addElement(collection: "questions", documentID: questionID, arrayName: "answerIDs", element: newAnswerID)
            await helper.addElement(collection: "users", documentID: username, arrayName: "answerIDs", element: newAnswerID)
            
            oldAnswer = answer
            loading = false
        }
    }
    
    func resubmitQuestion(questionID: String, username: String) async {
        newQuestionError = nil
        if newQuestion.isEmpty {
            newQuestionError = "Please enter a new question"
        } else {
            loading = true
            let newAnswerID = questionID + username
            await helper.updateData(collection: "answers", documentID: newAnswerID, data: [
                "answer": newQuestion
            ])
            loading = false
        }
    }
    
    // MARK: - Methods
    func stopQuestion(username: String) async {
        loading = true
        if let question = question {
            if question.end == nil {
                await helper.updateData(collection: "questions", documentID: question.id, data: [
                    "end": Date()
                ])
            }
        }
        await helper.deleteField(collection: "users", documentID: username, field: "liveQuestionID")
        loading = false
    }
    
    func toggleSharedAnswer(questionID: String, answerID: String, shared: Bool) async {
        loading = true
        if shared {
            await helper.removeElement(collection: "questions", documentID: questionID, arrayName: "sharedAnswerIDs", element: answerID)
        } else {
            await helper.addElement(collection: "questions", documentID: questionID, arrayName: "sharedAnswerIDs", element: answerID)
        }
        loading = false
    }
}
