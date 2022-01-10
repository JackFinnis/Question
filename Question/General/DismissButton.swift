//
//  DismissButton.swift
//  Question
//
//  Created by Jack Finnis on 10/01/2022.
//

import SwiftUI

struct DismissButton: View {
    @FocusState var focused1: Bool
    @FocusState var focused2: Bool
    
    var body: some View {
        if focused1 || focused2 {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button("Done") {
                        focused1 = false
                        focused2 = false
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
        }
    }
}
