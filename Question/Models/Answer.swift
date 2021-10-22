//
//  Answer.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import Foundation

struct Answer: Identifiable {
    let id: String
    let answer: String?
    let username: String?
    let question: String?
    let askerUsername: String?
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.answer = data["answer"] as? String
        self.username = data["username"] as? String
        self.question = data["question"] as? String
        self.askerUsername = data["askerUsername"] as? String
    }
}
