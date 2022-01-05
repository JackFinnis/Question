//
//  FirebaseHelper.swift
//  Ecommunity
//
//  Created by Jack Finnis on 08/10/2021.
//

import Foundation
import FirebaseFirestore

struct FirebaseHelper {
    // MARK: - Properties
    // Firebase database helper
    let database = Firestore.firestore()
    
    // MARK: - Document Listeners
    // Setup a listener for the given document in a collection
    func addDocumentListener(collection: String, documentID: String, completion: @escaping ([String : Any]?) -> Void) -> ListenerRegistration {
        database.collection(collection).document(documentID).addSnapshotListener { (document, error) in
            // Return document
            completion(document?.data())
        }
    }
    
    // Setup a listener for the given collection given a list of document IDs
    func addCollectionListener(collection: String, field: String, arrayContains: Any, completion: @escaping ([QueryDocumentSnapshot]) -> Void) -> ListenerRegistration? {
        // Fetch documents where the given field array contains given element
        return database.collection(collection).whereField(field, arrayContains: arrayContains).addSnapshotListener { (queryDocuments, error) in
            completion(queryDocuments?.documents ?? [])
        }
    }
    
    // Setup a listener for the given collection given a list of document IDs
    func addCollectionListener(collection: String, field: String, isEqualTo: Any, completion: @escaping ([QueryDocumentSnapshot]) -> Void) -> ListenerRegistration? {
        // Fetch documents where the given field array contains given element
        return database.collection(collection).whereField(field, isEqualTo: isEqualTo).addSnapshotListener { (queryDocuments, error) in
            completion(queryDocuments?.documents ?? [])
        }
    }
    
    // Setup a listener for all the documents in the given collection
    func addCollectionListener(collection: String, completion: @escaping ([QueryDocumentSnapshot]) -> Void) -> ListenerRegistration? {
        return database.collection(collection).addSnapshotListener { queryDocuments, error in
            completion(queryDocuments?.documents ?? [])
        }
    }
    
    // MARK: - General Static Fetching
    // Fetch static version of document from collection
    func getDocumentData(collection: String, documentID: String) async -> [String : Any]? {
        // Ensure data is found
        guard let data = try? await database.collection(collection).document(documentID).getDocument().data() else {
            print("Document not found")
            return nil
        }
        return data
    }
    
    // Fetch documents with given IDs
    func fetchDocuments(collection: String, documentIDs: [String]? = nil) async -> [QueryDocumentSnapshot] {
        if let snapshot = try? await database.collection(collection).getDocuments() {
            return snapshot.documents.filter { document in
                documentIDs == nil || documentIDs!.contains(document.documentID)
            }
        } else {
            return []
        }
    }
    
    // Fetch documents with given IDs
    func fetchDocuments(collection: String, field: String, equalTo: Any) async -> [QueryDocumentSnapshot] {
        if let snapshot = try? await database.collection(collection).whereField(field, isEqualTo: equalTo).getDocuments() {
            return snapshot.documents
        } else {
            return []
        }
    }
    
    // Fetch documents with given IDs
    func fetchDocuments(collection: String, field: String, arrayContains element: Any) async -> [QueryDocumentSnapshot] {
        if let snapshot = try? await database.collection(collection).whereField(field, arrayContains: element).getDocuments() {
            return snapshot.documents
        } else {
            return []
        }
    }
    
    // MARK: - Users
    // userID is the id of the user document that needs to be listened to
    func addUserListener(userID: String, completion: @escaping (User?) -> Void) -> ListenerRegistration {
        addDocumentListener(collection: "users", documentID: userID) { data in
            // Cast data as custom object
            completion(data == nil ? nil : User(id: userID, data: data!))
        }
    }
    
    // userIDs is a list of all the users that need to be listened to
    func addUsersListener(completion: @escaping ([User]) -> Void) -> ListenerRegistration? {
        addCollectionListener(collection: "users") { documents in
            // Convert the user documents into my custom User objects
            completion(documents.map { document -> User in
                return User(id: document.documentID, data: document.data())
            })
        }
    }
    
    // userIDs is a list of all the users that need to be listened to
    func fetchUsers(userIDs: [String]? = nil) async -> [User] {
        await fetchDocuments(collection: "users", documentIDs: userIDs).map { document in
            User(id: document.documentID, data: document.data())
        }
    }
    
    // Fetch static version of user object from Firebase with given userID
    func getUser(userID: String) async -> User? {
        // Fetch user document
        if let data = await getDocumentData(collection: "users", documentID: userID) {
            return User(id: userID, data: data)
        }
        // Error occured
        return nil
    }
    
    func getUniqueID() -> String {
        database.collection("users").document().documentID
    }
    
    // MARK: - General Updating Data
    // Add document to collection
    func addDocument(collection: String, documentID: String, data: [String : Any] = [:]) async {
        do {
            try await database.collection(collection).document(documentID).setData(data)
        } catch {
            // Error occured
            print("Add document failed")
        }
    }
    
    // Add document to collection
    func addDocument(collection: String, documentID: String, data: [String : Any]) {
        database.collection(collection).document(documentID).setData(data)
    }
    
    // Update data in given document
    func updateData(collection: String, documentID: String, data: [String : Any]) async {
        do {
            try await database.collection(collection).document(documentID).updateData(data)
        } catch {
            // Error occured
            print("Update data failed")
        }
    }
    
    // Update data in document not using async await
    func updateData(collection: String, documentID: String, data: [String : Any], completion: @escaping (Error?) -> Void) {
        database.collection(collection).document(documentID).updateData(data) { error in
            completion(error)
        }
    }
    
    // Add element to array in document in database
    func addElement(collection: String, documentID: String, arrayName: String, element: String) async {
        // Get document data
        if let data = await getDocumentData(collection: collection, documentID: documentID) {
            // Extract current data and add new element
            var array = data[arrayName] as? [String] ?? []
            if !array.contains(element) {
                array.append(element)
                // Update array in database
                await updateData(collection: collection, documentID: documentID, data: [arrayName : array])
            }
        }
    }
    
    // Remove element from array
    func removeElement(collection: String, documentID: String, arrayName: String, element: String) async {
        // Get document data
        if let data = await getDocumentData(collection: collection, documentID: documentID) {
            var array = data[arrayName] as? [String] ?? []
            // Remove all elements of array equal to value and update array in database
            array.removeAll(where: { $0 == element })
            await updateData(collection: collection, documentID: documentID, data: [arrayName : array])
        }
    }
    
    // Increment field in document by given value
    func increment(collection: String, documentID: String, field: String, value: Int) async {
        // Get document data
        if let data = await getDocumentData(collection: collection, documentID: documentID) {
            let newNumber = (data[field] as? Int ?? 0) + value
            // Save new incremented number to database
            await updateData(collection: collection, documentID: documentID, data: [field: newNumber])
        }
    }
    
    // Delete field from given document in collection
    func deleteField(collection: String, documentID: String, field: String) async {
        await updateData(collection: collection, documentID: documentID, data: [
            field: nil as String? as Any
        ])
    }
    
    // Delete document from given collection
    func deleteDocument(collection: String, documentID: String) async {
        try? await database.collection(collection).document(documentID).delete()
    }
    
    // MARK: - App Specific
    func isInUse(username: String) async -> Bool {
        let data = await getDocumentData(collection: "users", documentID: username)
        return data != nil
    }
}
