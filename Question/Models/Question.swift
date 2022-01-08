//
//  Question.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import Foundation
import FirebaseFirestore

struct Question: Identifiable, Hashable {
    let id: String
    let end: Date?
    let minutes: Int?
    let question: String?
    let answerIDs: [String]
    let askerUsername: String?
    let sharedAnswerIDs: [String]
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.minutes = data["minutes"] as? Int
        self.question = data["question"] as? String
        self.answerIDs = data["answerIDs"] as? [String] ?? []
        self.askerUsername = data["askerUsername"] as? String
        self.end = (data["end"] as? Timestamp)?.dateValue()
        self.sharedAnswerIDs = data["sharedAnswerIDs"] as? [String] ?? []
    }
}
