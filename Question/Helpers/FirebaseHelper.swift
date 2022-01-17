//
//  FirebaseHelper.swift
//  Ecommunity
//
//  Created by Jack Finnis on 08/10/2021.
//

import Foundation
import Firebase
import FirebaseFirestore

struct FirebaseHelper {
    // MARK: - Properties
    let database: Firestore
    var nothing: String?
    let haptics = HapticsHelper()
    
    // MARK: - Initialiser
    init() {
        let settings = FirestoreSettings()
        let database = Firestore.firestore()
        settings.isPersistenceEnabled = false
        database.settings = settings
        self.database = database
    }
    
    // MARK: - Document Listeners
    func addDocumentListener(collection: String, documentID: String, completion: @escaping ([String : Any]?) -> Void) -> ListenerRegistration {
        database.collection(collection).document(documentID).addSnapshotListener { (document, error) in
            completion(document?.data())
        }
    }
    
    // Setup a listener for the given collection given a list of document IDs
    func addCollectionListener(collection: String, field: String, arrayContains: Any, completion: @escaping ([QueryDocumentSnapshot]) -> Void) -> ListenerRegistration? {
        return database.collection(collection).whereField(field, arrayContains: arrayContains).addSnapshotListener { (queryDocuments, error) in
            completion(queryDocuments?.documents ?? [])
        }
    }
    
    func addCollectionListener(collection: String, field: String, isEqualTo: Any, completion: @escaping ([QueryDocumentSnapshot]) -> Void) -> ListenerRegistration? {
        return database.collection(collection).whereField(field, isEqualTo: isEqualTo).addSnapshotListener { (queryDocuments, error) in
            completion(queryDocuments?.documents ?? [])
        }
    }
    
    func addCollectionListener(collection: String, completion: @escaping ([QueryDocumentSnapshot]) -> Void) -> ListenerRegistration? {
        return database.collection(collection).addSnapshotListener { queryDocuments, error in
            completion(queryDocuments?.documents ?? [])
        }
    }
    
    // MARK: - General Static Fetching
    func getDocumentData(collection: String, documentID: String) async -> [String : Any]? {
        try? await database.collection(collection).document(documentID).getDocument().data()
    }
    
    func fetchDocuments(collection: String, documentIDs: [String]? = nil) async -> [QueryDocumentSnapshot] {
        let snapshot = try? await database.collection(collection).getDocuments()
        return snapshot?.documents.filter { document in
            documentIDs == nil || documentIDs!.contains(document.documentID)
        } ?? []
    }
    
    func fetchDocuments(collection: String, field: String, equalTo: Any) async -> [QueryDocumentSnapshot] {
        let snapshot = try? await database.collection(collection).whereField(field, isEqualTo: equalTo).getDocuments()
        return snapshot?.documents ?? []
    }
    
    func fetchDocuments(collection: String, field: String, arrayContains element: Any) async -> [QueryDocumentSnapshot] {
        let snapshot = try? await database.collection(collection).whereField(field, arrayContains: element).getDocuments()
        return snapshot?.documents ?? []
    }
    
    // MARK: - Users
    func addUserListener(userID: String, completion: @escaping (User?) -> Void) -> ListenerRegistration {
        addDocumentListener(collection: "users", documentID: userID) { data in
            completion(User(id: userID, data: data))
        }
    }
    
    func addUsersListener(completion: @escaping ([User]) -> Void) -> ListenerRegistration? {
        addCollectionListener(collection: "users") { documents in
            completion(documents.compactMap { document in
                User(id: document.documentID, data: document.data())
            })
        }
    }
    
    func fetchUsers(userIDs: [String]? = nil) async -> [User] {
        await fetchDocuments(collection: "users", documentIDs: userIDs).compactMap { document in
            User(id: document.documentID, data: document.data())
        }
    }
    
    func getUser(userID: String) async -> User? {
        let data = await getDocumentData(collection: "users", documentID: userID)
        return User(id: userID, data: data)
    }
    
    func getUniqueID() -> String {
        database.collection("users").document().documentID
    }
    
    // MARK: - General Updating Data
    func addDocument(collection: String, documentID: String, data: [String : Any] = [:]) async {
        try? await database.collection(collection).document(documentID).setData(data)
    }
    
    func updateData(collection: String, documentID: String, data: [String : Any]) async {
        try? await database.collection(collection).document(documentID).updateData(data)
    }
    
    func addElement(collection: String, documentID: String, arrayName: String, element: String) async {
        if let data = await getDocumentData(collection: collection, documentID: documentID) {
            var array = data[arrayName] as? [String] ?? []
            if !array.contains(element) {
                array.append(element)
                await updateData(collection: collection, documentID: documentID, data: [arrayName : array])
            }
        }
    }
    
    func removeElement(collection: String, documentID: String, arrayName: String, element: String) async {
        if let data = await getDocumentData(collection: collection, documentID: documentID) {
            var array = data[arrayName] as? [String] ?? []
            array.removeAll { $0 == element }
            await updateData(collection: collection, documentID: documentID, data: [arrayName : array])
        }
    }
    
    func increment(collection: String, documentID: String, field: String, value: Int) async {
        if let data = await getDocumentData(collection: collection, documentID: documentID) {
            let newNumber = (data[field] as? Int ?? 0) + value
            await updateData(collection: collection, documentID: documentID, data: [field: newNumber])
        }
    }
    
    func deleteField(collection: String, documentID: String, field: String) async {
        await updateData(collection: collection, documentID: documentID, data: [
            field: nothing as Any
        ])
    }
    
    func deleteDocument(collection: String, documentID: String) async {
        try? await database.collection(collection).document(documentID).delete()
    }
    
    // MARK: - App Specific
    func isInUse(username: String) async -> Bool {
        let data = await getDocumentData(collection: "users", documentID: username)
        return data != nil
    }
    
    func leaveLiveRoom(username: String) async {
        await deleteField(collection: "users", documentID: username, field: "liveJoinUsername")
        haptics.success()
    }
    
    func joinRoom(username: String, joinUsername: String? = nil) async {
        if let joinUsername = joinUsername {
            UserDefaults.standard.set(joinUsername, forKey: "joinUsername")
        }
        if let joinUsername = UserDefaults.standard.string(forKey: "joinUsername") {
            await addElement(collection: "users", documentID: joinUsername, arrayName: "guestUsernames", element: username)
        }
    }
    
    func leaveRoom(username: String) async {
        if let joinUsername = UserDefaults.standard.string(forKey: "joinUsername") {
            await removeElement(collection: "users", documentID: joinUsername, arrayName: "guestUsernames", element: username)
        }
    }
    
    func leaveRoomFully(username: String) async {
        if let joinUsername = UserDefaults.standard.string(forKey: "joinUsername") {
            await removeElement(collection: "users", documentID: joinUsername, arrayName: "guestUsernames", element: username)
        }
        UserDefaults.standard.set(nil, forKey: "joinUsername")
    }
}
