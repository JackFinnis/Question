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
    let share: Bool
    let end: Date?
    let username: String?
    let question: String?
    let answers: [String]
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.share = data["share"] as? Bool ?? false
        self.end = (data["end"] as? Timestamp)?.dateValue() ?? Date()
        self.username = data["username"] as? String
        self.question = data["question"] as? String
        self.answers = data["answers"] as? [String] ?? []
    }
}
