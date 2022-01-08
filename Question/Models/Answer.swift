//
//  Answer.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import Foundation
import Firebase

struct Answer: Identifiable {
    let id: String
    let date: Date
    let answer: String?
    let questionID: String?
    let askerUsername: String?
    let answerUsername: String?
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.answer = data["answer"] as? String
        self.questionID = data["questionID"] as? String
        self.askerUsername = data["askerUsername"] as? String
        self.answerUsername = data["answerUsername"] as? String
        self.date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
    }
}
