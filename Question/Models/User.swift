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
    let liveQuestionID: String?
    let answerIDs: [String]
    let questionIDs: [String]
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.username = data["username"] as? String
        self.liveQuestionID = data["liveQuestionID"] as? String
        self.answerIDs = data["answerIDs"] as? [String] ?? []
        self.questionIDs = data["questionIDs"] as? [String] ?? []
    }
}
