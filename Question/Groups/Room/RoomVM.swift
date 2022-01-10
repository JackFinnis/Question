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
    let haptics = HapticsHelper()
    
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
    
    // MARK: - Methods
    func joinRoom(username: String, joinUsername: String) async {
        await helper.addElement(collection: "users", documentID: joinUsername, arrayName: "guestUsernames", element: username)
    }
    
    func leaveRoom(username: String, joinUsername: String) async {
        await helper.removeElement(collection: "users", documentID: joinUsername, arrayName: "guestUsernames", element: username)
    }
}
