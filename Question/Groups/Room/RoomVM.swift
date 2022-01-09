//
//  RoomVM.swift
//  Question
//
//  Created by Jack Finnis on 05/01/2022.
//

import Foundation
import FirebaseFirestore

@MainActor
class RoomVM: ObservableObject {
    // MARK: - Properties
    @Published var user: User?
    
    let helper = FirebaseHelper()
    
    var userListener: ListenerRegistration?
    
    // MARK: - Listeners
    func addUserListener(username: String) {
        userListener?.remove()
        userListener = helper.addUserListener(userID: username) { user in
            self.user = user
        }
    }
    
    func removeListeners() {
        userListener?.remove()
    }
}
