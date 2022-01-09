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
        HStack {
            VStack(alignment: .leading) {
                Text(answer.answerUsername ?? "Anonymous")
                    .bold()
                Text(answer.answer ?? "No Answer")
            }
            Spacer()
            CopyButton(answer: answer)
        }
        .contextMenu {
            CopyButton(answer: answer)
        }
        .swipeActions {
            CopyButton(answer: answer)
        }
    }
}
