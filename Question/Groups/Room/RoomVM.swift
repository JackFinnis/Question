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
    @Published var question: Question?
    
    @Published var loading = false
    
    let helper = FirebaseHelper()
    
    var userListener: ListenerRegistration?
    
    // MARK: - Listeners
    func addUserListener(username: String) {
        loading = true
        userListener?.remove()
        userListener = helper.addUserListener(userID: username) { user in
            self.user = user
            self.loading = false
        }
    }
    
    func removeListeners() {
        userListener?.remove()
    }
    
    // MARK: - Methods
    func stopLiveQuestion(username: String) async {
        //todo
    }
}
