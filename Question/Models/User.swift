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
    let liveJoinUsername: String?
    let guestUsernames: [String]
    let usernamesBlockedYou: [String]
    let usernamesYouBlocked: [String]
    
    init(id: String, data: [String: Any]) {
        self.username = id
        self.liveQuestionID = data["liveQuestionID"] as? String
        self.liveJoinUsername = data["liveJoinUsername"] as? String
        self.guestUsernames = data["guestUsernames"] as? [String] ?? []
        self.usernamesBlockedYou = data["usernamesBlockedYou"] as? [String] ?? []
        self.usernamesYouBlocked = data["usernamesYouBlocked"] as? [String] ?? []
    }
}
