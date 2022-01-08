//
//  AnswerUserRow.swift
//  Question
//
//  Created by Jack Finnis on 07/01/2022.
//

import SwiftUI

struct AnswerUserRow: View {
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
