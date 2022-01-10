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
    var oldAnswer = ""
    var unsavedChanges: Bool { answer.isEmpty || oldAnswer != answer }
    
    var updated = false
    @Published var newQuestion = ""
    @Published var newQuestionError: String?
    @Published var newTimedQuestion = true
    @Published var newQuestionMinutes: Int = 2
    
    @Published var timeIntervalRemaining: TimeInterval = 0
    var isLive: Bool {
        question?.end == nil || question!.end! > Date()
    }
    var formattedTimeRemaining: String {
        if question?.end == nil {
            return "Live"
        } else if timeIntervalRemaining <= 0 {
            return "Finished"
        } else {
            return DateComponentsFormatter().string(from: timeIntervalRemaining)!
        }
    }
    
    let helper = FirebaseHelper()
    let haptics = HapticsHelper()
    
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
                // Update text editor
                if !self.updated {
                    self.updated = true
                    self.newQuestion = self.question?.question ?? "No Question"
                }
                // Update countdown
                self.timeIntervalRemaining = self.question?.end?.timeIntervalSinceNow ?? 0
            } else {
                self.question = nil
                self.error = true
            }
        }
    }
    
    func addAnswersListener(questionID: String, username: String) {
        answersListener?.remove()
        answersListener = helper.addCollectionListener(collection: "answers", field: "questionID", isEqualTo: questionID) { documents in
            self.answers = documents.map { document -> Answer in
                Answer(id: document.documentID, data: document.data())
            }.sorted { $0.date < $1.date }
            
            if let previousAnswer = self.answers.first(where: { $0.answerUsername == username }) {
                if self.answer.isEmpty {
                    self.answer = previousAnswer.answer ?? ""
                    self.oldAnswer = previousAnswer.answer ?? ""
                }
            }
        }
    }
    
    func removeListeners() {
        questionListener?.remove()
        answersListener?.remove()
    }
    
    func addListeners(questionID: String, username: String) {
        addQuestionListener(questionID: questionID)
        addAnswersListener(questionID: questionID, username: username)
    }
    
    // MARK: - Methods
    func submitAnswer(questionID: String, username: String, joinUsername: String) async {
        answerError = nil
        if answer.isEmpty {
            answerError = "Please enter an answer"
            haptics.error()
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
            
            haptics.success()
            oldAnswer = answer
            loading = false
        }
    }
    
    func stopQuestion(username: String, questionID: String) async {
        loading = true
        await helper.updateData(collection: "questions", documentID: questionID, data: [
            "end": Date()
        ])
        haptics.success()
        loading = false
    }
    
    func stopLiveQuestion(username: String) async {
        loading = true
        await helper.deleteField(collection: "users", documentID: username, field: "liveQuestionID")
        haptics.success()
        loading = false
    }
    
    func toggleSharedAnswer(questionID: String, answerID: String, shared: Bool) async {
        loading = true
        if shared {
            await helper.removeElement(collection: "questions", documentID: questionID, arrayName: "sharedAnswerIDs", element: answerID)
        } else {
            await helper.addElement(collection: "questions", documentID: questionID, arrayName: "sharedAnswerIDs", element: answerID)
        }
        haptics.success()
        loading = false
    }
    
    func submitNewQuestion(questionID: String) async {
        newQuestionError = nil
        if newQuestion.isEmpty {
            newQuestionError = "Please enter a new question"
            haptics.error()
        } else {
            loading = true
            await helper.updateData(collection: "questions", documentID: questionID, data: [
                "question": newQuestion
            ])
            haptics.success()
            loading = false
        }
    }
    
    func submitNewTimeLimit(questionID: String) async {
        loading = true
        var endDate: Date?
        if newTimedQuestion {
            endDate = Date().addingTimeInterval(Double(newQuestionMinutes * 60))
        }
        await helper.updateData(collection: "questions", documentID: questionID, data: [
            "end": endDate as Any,
            "minutes": newQuestionMinutes
        ])
        haptics.success()
        loading = false
    }
    
    func shareAllAnswers(question: Question) async {
        loading = true
        await helper.updateData(collection: "questions", documentID: question.id, data: [
            "sharedAnswerIDs": question.answerIDs
        ])
        haptics.success()
        loading = false
    }
}
