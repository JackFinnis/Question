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
    let db = Firestore.firestore()
    
    // MARK: - General Listeners
    func addDocumentListener(collection: String, documentID: String, completion: @escaping ([String : Any]) -> Void) -> ListenerRegistration {
        db.collection(collection).document(documentID).addSnapshotListener(includeMetadataChanges: true) { (document, error) in
            if let document = document, let data = document.data() {
                if !document.metadata.hasPendingWrites {
                    completion(data)
                }
            }
        }
    }
    
    func addCollectionListener(collection: String, documentIDs: [String]?, completion: @escaping ([QueryDocumentSnapshot]) -> Void) -> ListenerRegistration {
        db.collection(collection).addSnapshotListener(includeMetadataChanges: true) { (queryDocuments, error) in
            if let queryDocuments = queryDocuments {
                if !queryDocuments.metadata.hasPendingWrites {
                    completion(queryDocuments.documents.filter { document in
                        documentIDs == nil || documentIDs!.contains(document.documentID)
                    })
                }
            }
        }
    }
    
    func addCollectionListenerWhereArrayContains(collection: String, arrayName: String, contains: Any, completion: @escaping ([QueryDocumentSnapshot]) -> Void) -> ListenerRegistration {
        db.collection(collection).whereField(arrayName, arrayContains: contains).addSnapshotListener(includeMetadataChanges: true) { (queryDocuments, error) in
            if let queryDocuments = queryDocuments {
                if !queryDocuments.metadata.hasPendingWrites {
                    completion(queryDocuments.documents)
                }
            }
        }
    }
    
    func addCollectionListenerWhereFieldEquals(collection: String, field: String, equalTo: Any, completion: @escaping ([QueryDocumentSnapshot]) -> Void) -> ListenerRegistration {
        db.collection(collection).whereField(field, isEqualTo: equalTo).addSnapshotListener(includeMetadataChanges: true) { (queryDocuments, error) in
            if let queryDocuments = queryDocuments {
                if !queryDocuments.metadata.hasPendingWrites {
                    completion(queryDocuments.documents)
                }
            }
        }
    }
    
    func addCollectionListenerWhereFieldEqualsAny(collection: String, arrayName: String, conatinsAny: [Any], completion: @escaping ([QueryDocumentSnapshot]) -> Void) -> ListenerRegistration {
        db.collection(collection).whereField(arrayName, arrayContainsAny: conatinsAny).addSnapshotListener(includeMetadataChanges: true) { (queryDocuments, error) in
            if let queryDocuments = queryDocuments {
                if !queryDocuments.metadata.hasPendingWrites {
                    completion(queryDocuments.documents)
                }
            }
        }
    }
    
    // MARK: - General Static Fetching
    func getDocumentData(collection: String, documentID: String) async -> [String : Any]? {
        if let document = try? await db.collection(collection).document(documentID).getDocument() {
            if !document.metadata.hasPendingWrites {
                return document.data()
            }
        }
        return nil
    }
    
    func getDocumentsWhere(collection: String, field: String, equalTo: Any) async -> [QueryDocumentSnapshot] {
        let query = db.collection(collection).whereField(field, isEqualTo: equalTo)
        if let snapshot = try? await query.getDocuments() {
            if !snapshot.metadata.hasPendingWrites {
                return snapshot.documents
            }
        }
        return []
    }
    
    func getUniqueID() -> String {
        db.collection("users").document().documentID
    }
    
    // MARK: - General Updating Data
    func addDocument(collection: String, documentID: String, data: [String : Any]) async {
        try? await db.collection(collection).document(documentID).setData(data)
    }
    
    func updateData(collection: String, documentID: String, data: [String : Any]) async {
        try? await db.collection(collection).document(documentID).updateData(data)
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
            if let index = array.firstIndex(of: element) {
                array.remove(at: index)
                await updateData(collection: collection, documentID: documentID, data: [arrayName : array])
            }
        }
    }
    
    // MARK: - General Deleting
    func removeDocument(collection: String, documentID: String) async {
        try? await db.collection(collection).document(documentID).delete()
    }
    
    // MARK: - Specific Helper Functions
    func addUserListener(userID: String, completion: @escaping (User) -> Void) -> ListenerRegistration {
        addDocumentListener(collection: "users", documentID: userID) { data in
            completion(User(id: userID, data: data))
        }
    }
    
    func addUsersListener(userIDs: [String]?, completion: @escaping ([User]) -> Void) -> ListenerRegistration {
        addCollectionListener(collection: "users", documentIDs: userIDs) { documents in
            completion(documents.map { document -> User in
                User(id: document.documentID, data: document.data())
            })
        }
    }
    
    func getUser(userID: String) async -> User? {
        if let data = await getDocumentData(collection: "users", documentID: userID) {
            return User(id: userID, data: data)
        }
        return nil
    }
}
