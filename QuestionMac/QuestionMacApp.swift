//
//  QuestionMacApp.swift
//  QuestionMac
//
//  Created by Jack Finnis on 10/01/2022.
//

import SwiftUI

@main
struct QuestionMacApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
