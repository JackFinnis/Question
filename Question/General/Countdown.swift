//
//  Countdown.swift
//  Question
//
//  Created by Jack Finnis on 10/01/2022.
//

import SwiftUI

struct Countdown: View {
    @ObservedObject var questionVM: QuestionVM
    
    var body: some View {
        Text(questionVM.formattedTimeRemaining)
            .foregroundColor(questionVM.timeIntervalRemaining < 10.5 && questionVM.timeIntervalRemaining > 0 ? .red : .none)
    }
}
