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
    @Published var question: Question? { didSet {
        Task {
            if (question?.finished ?? false) && unsavedChanges {
                await submitAnswer()
            }
        }
    }}
    
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
    
    func removeListeners() {
        questionListener?.remove()
    }
    
    // MARK: - Methods
    func submitAnswer() async {
        answerError = nil
        if answer.isEmpty {
            answerError = "Please enter an answer"
        } else {
            loading = true
            //todo
            oldAnswer = answer
            loading = false
        }
    }
    
    func submitNewQuestion() async {
        newQuestionError = nil
        if newQuestion.isEmpty {
            newQuestionError = "Please enter a new question"
        } else {
            loading = true
            //todo
            loading = false
        }
    }
}
