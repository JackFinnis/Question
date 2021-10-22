//
//  User.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import Foundation

struct User: Identifiable {
    let id: String
    let username: String?
    let answers: [String]
    let questions: [String]
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.username = data["username"] as? String
        self.answers = data["answers"] as? [String] ?? []
        self.questions = data["questions"] as? [String] ?? []
    }
}
