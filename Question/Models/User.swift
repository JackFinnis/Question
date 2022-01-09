//
//  User.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import Foundation

struct User {
    let username: String?
    let liveQuestionID: String?
    let answerIDs: [String]
    let questionIDs: [String]
    let guestUsernames: [String]
    let liveRoomUsernames: [String]
    
    init(id: String, data: [String: Any]) {
        self.username = id
        self.liveQuestionID = data["liveQuestionID"] as? String
        self.answerIDs = data["answerIDs"] as? [String] ?? []
        self.questionIDs = data["questionIDs"] as? [String] ?? []
        self.guestUsernames = data["guestUsernames"] as? [String] ?? []
        self.liveRoomUsernames = data["liveRoomUsernames"] as? [String] ?? []
    }
}
