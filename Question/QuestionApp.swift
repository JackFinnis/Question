//
//  QuestionApp.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import SwiftUI
import Firebase

@main
struct QuestionApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    @StateObject var vm = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(vm)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
