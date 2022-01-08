//
//  AnswerRow.swift
//  Question
//
//  Created by Jack Finnis on 07/01/2022.
//

import SwiftUI

struct AnswerRow: View {
    let answer: Answer
    
    var body: some View {
        VStack {
            Text(answer.answer ?? "No Answer")
            HStack {
                Spacer()
                Text(answer.answerUsername ?? "Anonymous")
            }
        }
    }
}
