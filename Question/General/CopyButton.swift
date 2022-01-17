//
//  CopyButton.swift
//  Question
//
//  Created by Jack Finnis on 09/01/2022.
//

import SwiftUI

struct CopyButton: View {
    let string: String?
    
    let clipboardHelper = ClipboardHelper()
    
    var body: some View {
        if string != nil && !string!.isEmpty {
            Button {
                clipboardHelper.copy(string: string!)
            } label: {
                Label("Copy Answer", systemImage: "doc.on.doc")
            }
        }
    }
}
