//
//  ViewModel.swift
//  Ecommunity
//
//  Created by Jack Finnis on 22/09/2021.
//

import FirebaseAuth
import FirebaseFirestore

@MainActor
class ViewModel: ObservableObject {
    // MARK: - Properties
    @Published var username: String = ""
    @Published var errorMessage: String?
    @Published var loading: Bool = false
    
    let db = Firestore.firestore()
    let helper = FirebaseHelper()
    
    // MARK: - Methods
    func createAccount() async {
        // todo
    }
}
