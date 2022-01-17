//
//  UserVM.swift
//  Question
//
//  Created by Jack Finnis on 05/01/2022.
//

import Foundation
import FirebaseFirestore

@MainActor
class UserVM: ObservableObject {
    // MARK: - Properties
    @Published var user: User?
    @Published var loading = false
    @Published var questions = [Question]()
    @Published var answers = [Answer]() { didSet {
        filterRecentUsernames()
    }}
    
    @Published var showRoomView = false
    @Published var showMyQuestionView = false
    
    @Published var joinUsername = ""
    @Published var joinUsernameError: String?
    @Published var recentUsernames = [String]()
    
    @Published var newQuestion = ""
    @Published var newQuestionError: String?
    @Published var timedQuestion = false
    @Published var newQuestionMinutes: Int = 2
    @Published var selectedRecentQuestion: Question? { didSet {
        newQuestion = selectedRecentQuestion?.question ?? newQuestion
        if let minutes = selectedRecentQuestion?.minutes {
            newQuestionMinutes = minutes
            timedQuestion = true
        } else {
            timedQuestion = false
        }
    }}
    
    @Published var filteredQuestions = [Question]()
    @Published var questionsSearchText = "" { didSet {
        filterQuestions()
    }}
    
    @Published var filteredAnswers = [Answer]()
    @Published var answersSearchText = "" { didSet {
        filterAnswers()
    }}
    
    let helper = FirebaseHelper()
    let haptics = HapticsHelper()
    
    var userListener: ListenerRegistration?
    var answersListener: ListenerRegistration?
    var questionsListener: ListenerRegistration?
    
    // MARK: - Listeners
    func addUserListener(username: String) {
        loading = true
        userListener?.remove()
        userListener = helper.addUserListener(userID: username) { user in
            self.loading = false
            self.user = user
            self.showRoomView = user?.liveJoinUsername != nil
            self.showMyQuestionView = user?.liveQuestionID != nil
        }
    }
    
    func addAnswersListener(username: String) {
        answersListener?.remove()
        answersListener = helper.addCollectionListener(collection: "answers", field: "answerUsername", isEqualTo: username) { documents in
            self.answers = documents.compactMap { document in
                Answer(id: document.documentID, data: document.data())
            }.sorted { $0.date > $1.date }
            self.filterAnswers()
        }
    }

    func addQuestionsListener(username: String) {
        questionsListener?.remove()
        questionsListener = helper.addCollectionListener(collection: "questions", field: "askerUsername", isEqualTo: username) { documents in
            self.questions = documents.compactMap { document in
                Question(id: document.documentID, data: document.data())
            }.sorted { $0.end ?? Date() > $1.end ?? Date() }
            self.filterQuestions()
        }
    }
    
    func addListeners(username: String) {
        addUserListener(username: username)
        addAnswersListener(username: username)
        addQuestionsListener(username: username)
    }
    
    func removeListeners() {
        answersListener?.remove()
        questionsListener?.remove()
    }
    
    // MARK: - Methods
    func filterAnswers() {
        filteredAnswers = answers.filter {
            answersSearchText.isEmpty ||
            $0.answer?.localizedCaseInsensitiveContains(answersSearchText) ?? false
        }
    }
    
    func filterQuestions() {
        filteredQuestions = questions.filter {
            questionsSearchText.isEmpty ||
            $0.question?.localizedCaseInsensitiveContains(questionsSearchText) ?? false
        }
    }
    
    func filterRecentUsernames() {
        var recentUsernames = [String]()
        for answer in answers {
            if let askerUsername = answer.askerUsername, !recentUsernames.contains(askerUsername) {
                recentUsernames.append(askerUsername)
            }
        }
        self.recentUsernames = recentUsernames
    }
    
    func submitJoinUser(username: String, usernamesBlockedYou: [String]) async {
        loading = true
        joinUsernameError = nil
        if joinUsername.isEmpty {
            joinUsernameError = "Please enter a username"
        } else if joinUsername == username {
            joinUsernameError = "Please enter a different username"
        } else if usernamesBlockedYou.contains(joinUsername) {
            joinUsernameError = joinUsername + " has blocked you from joining their room"
        } else if await !helper.isInUse(username: joinUsername) {
            joinUsernameError = "User does not exist"
        } else {
            await helper.updateData(collection: "users", documentID: username, data: [
                "liveJoinUsername": joinUsername
            ])
            haptics.success()
            joinUsername = ""
            loading = false
            return
        }
        haptics.error()
        loading = false
    }
    
    func startQuestion(username: String) async {
        newQuestionError = nil
        if newQuestion.isEmpty {
            newQuestionError = "Please enter a question"
            haptics.error()
        } else {
            loading = true
            let newQuestionID = helper.getUniqueID()
            var endDate: Date?
            if timedQuestion {
                endDate = Date().addingTimeInterval(Double(newQuestionMinutes * 60))
            }
            
            await helper.addDocument(collection: "questions", documentID: newQuestionID, data: [
                "end": endDate as Any,
                "askerUsername": username,
                "question": newQuestion,
                "minutes": timedQuestion ? newQuestionMinutes : helper.nothing as Any
            ])
            await helper.updateData(collection: "users", documentID: username, data: [
                "liveQuestionID": newQuestionID
            ])
            
            haptics.success()
            newQuestion = ""
            loading = false
        }
    }
}
