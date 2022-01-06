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
    
    @Published var loading = false
    @Published var error = false
    
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
}
