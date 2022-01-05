//
//  Question.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import Foundation
import FirebaseFirestore

struct Question: Identifiable {
    let id: String
    let end: Date?
    let question: String?
    let answerIDs: [String]
    let askerUsername: String?
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.end = (data["end"] as? Timestamp)?.dateValue() ?? Date()
        self.askerUsername = data["askerUsername"] as? String
        self.question = data["question"] as? String
        self.answerIDs = data["answerIDs"] as? [String] ?? []
    }
}
