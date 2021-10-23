//
//  ViewModel.swift
//  Ecommunity
//
//  Created by Jack Finnis on 22/09/2021.
//

import Foundation
import FirebaseFirestore

@MainActor
class ViewModel: ObservableObject {
    // MARK: - Properties
    // General
    @Published var user: User?
    @Published var loading: Bool = false
    
    // Create Account
    @Published var username: String = ""
    @Published var errorMessage: String?
    
    let db = Firestore.firestore()
    let helper = FirebaseHelper()
    
    // MARK: - Methods
    func createAccount() async {
        // todo
    }
}
