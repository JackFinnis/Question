//
//  QuestionMacApp.swift
//  QuestionMac
//
//  Created by Jack Finnis on 10/01/2022.
//

import SwiftUI
import Firebase

@main
struct QuestionMacApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
