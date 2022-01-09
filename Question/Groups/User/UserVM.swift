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
    @Published var answers = [Answer]() { didSet {
        filterRecentUsernames()
    }}
    @Published var questions = [Question]()
    @Published var loading = false
    @Published var reset = true

    @Published var showRoomView = false
    @Published var showMyRoomView = false
    
    @Published var joinUsername = ""
    @Published var joinUsernameError: String?
    
    @Published var recentUsernames = [String]()
    
    @Published var filteredAnswers = [Answer]()
    @Published var answersSearchText = "" { didSet {
        filterAnswers()
    }}
    
    @Published var selectedRecentQuestion: Question? { didSet {
        newQuestion = selectedRecentQuestion?.question ?? newQuestion
        if let minutes = selectedRecentQuestion?.minutes {
            newQuestionMinutes = minutes
            timedQuestion = true
        } else {
            timedQuestion = false
        }
    }}
    
    @Published var newQuestionID: String?
    @Published var newQuestion = ""
    @Published var newQuestionError: String?
    
    @Published var timedQuestion = false
    @Published var newQuestionMinutes: Int = 2
    
    @Published var filteredRecentQuestions = [Question]()
    @Published var filteredQuestions = [Question]()
    @Published var questionsSearchText = "" { didSet {
        filterQuestions()
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
            // Make sure user isn't in any rooms
            if self.reset, let user = user, !user.liveRoomUsernames.isEmpty {
                self.reset = false
                for joinUsername in user.liveRoomUsernames {
                    Task {
                        await self.helper.leaveRoom(username: username, joinUsername: joinUsername)
                    }
                }
            }
        }
    }
    
    func addAnswersListener(username: String) {
        answersListener?.remove()
        answersListener = helper.addCollectionListener(collection: "answers", field: "answerUsername", isEqualTo: username) { documents in
            self.answers = documents.map { document -> Answer in
                Answer(id: document.documentID, data: document.data())
            }.sorted { $0.date > $1.date }
            self.filterAnswers()
        }
    }

    func addQuestionsListener(username: String) {
        questionsListener?.remove()
        questionsListener = helper.addCollectionListener(collection: "questions", field: "askerUsername", isEqualTo: username) { documents in
            self.questions = documents.map { document -> Question in
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
    
    func submitJoinUser(username: String) async {
        loading = true
        joinUsernameError = nil
        if joinUsername.isEmpty {
            joinUsernameError = "Please enter a username"
        } else if joinUsername == username {
            joinUsernameError = "Please enter a different username"
        } else if await helper.isInUse(username: joinUsername) {
            showRoomView = true
            haptics.success()
            loading = false
            return
        } else {
            joinUsernameError = "User does not exist"
        }
        haptics.error()
        loading = false
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
            await helper.addElement(collection: "users", documentID: username, arrayName: "questionIDs", element: newQuestionID)
            
            haptics.success()
            loading = false
            self.newQuestionID = newQuestionID
            showMyRoomView = true
        }
    }
}
