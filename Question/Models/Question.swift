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
    let sharedAnswerID: String?
    
    var finished: Bool { end ?? Date() < Date() }
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.minutes = data["minutes"] as? Int
        self.question = data["question"] as? String
        self.answerIDs = data["answerIDs"] as? [String] ?? []
        self.askerUsername = data["askerUsername"] as? String
        self.sharedAnswerID = data["sharedAnswerID"] as? String
        self.end = (data["end"] as? Timestamp)?.dateValue() ?? Date()
    }
}
