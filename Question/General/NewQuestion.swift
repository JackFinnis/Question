//
//  NewQuestion.swift
//  Question
//
//  Created by Jack Finnis on 06/01/2022.
//

import SwiftUI

struct NewQuestion: View {
    @Binding var loading: Bool
    @Binding var finished: Bool
    
    @State var newQuestion = ""
    @State var newQuestionMinutes: Double?
    @State var newQuestionError: String?
    
    let username: String
    
    let helper = FirebaseHelper()
    
    var body: some View {
        Section {
            TextField("Enter Question", text: $newQuestion)
                .submitLabel(.go)
            
            Button("Start") {
                Task {
                    await startQuestion(username: username)
                }
            }
        } header: {
            Text("Start a Question")
        } footer: {
            Text(newQuestionError ?? "")
        }
        .headerProminence(.increased)
        .onSubmit {
            Task {
                await startQuestion(username: username)
            }
        }
    }
    
    @MainActor
    func startQuestion(username: String) async {
        newQuestionError = nil
        if newQuestion.isEmpty {
            newQuestionError = "Please enter a question"
        } else {
            loading = true
            let newQuestionID = helper.getUniqueID()
            var endDate: Date?
            if newQuestionMinutes != nil {
                endDate = Date().addingTimeInterval(newQuestionMinutes! * 60)
            }
            
            await helper.addDocument(collection: "questions", documentID: newQuestionID, data: [
                "end": endDate as Any,
                "askerUsername": username,
                "question": newQuestion
            ])
            await helper.updateData(collection: "users", documentID: username, data: [
                "liveQuestion": newQuestionID
            ])
            await helper.addElement(collection: "users", documentID: username, arrayName: "questionIDs", element: newQuestionID)
            
            loading = false
            finished = true
        }
    }
}
