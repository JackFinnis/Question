//
//  CopyButton.swift
//  Question
//
//  Created by Jack Finnis on 09/01/2022.
//

import SwiftUI

struct CopyButton: View {
    let answer: Answer
    
    let haptics = HapticsHelper()
    
    var body: some View {
        if answer.answer != nil && !answer.answer!.isEmpty {
            Button {
                let pasteboard = UIPasteboard.general
                pasteboard.string = answer.answer!
                haptics.success()
            } label: {
                Label("Copy Answer", systemImage: "doc.on.doc")
            }
        }
    }
}
