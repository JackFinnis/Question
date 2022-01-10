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
                #if os(macOS)
                let pasteboard = NSPasteboard.general
                pasteboard.setString(string!, forType: .string)
                #else
                let pasteboard = UIPasteboard.general
                pasteboard.string = string!
                #endif
                haptics.success()
            } label: {
                Label("Copy Answer", systemImage: "doc.on.doc")
            }
        }
    }
}
