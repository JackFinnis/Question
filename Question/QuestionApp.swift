//
//  QuestionApp.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import SwiftUI

@main
struct QuestionApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
