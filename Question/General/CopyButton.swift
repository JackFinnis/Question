//
//  CopyButton.swift
//  Question
//
//  Created by Jack Finnis on 09/01/2022.
//

import SwiftUI

struct CopyButton: View {
    let string: String?
    
    let haptics = HapticsHelper()
    
    var body: some View {
        if string != nil && !string!.isEmpty {
            Button {
                let pasteboard = UIPasteboard.general
                pasteboard.string = string!
                haptics.success()
            } label: {
                Label("Copy Answer", systemImage: "doc.on.doc")
            }
        }
    }
}
