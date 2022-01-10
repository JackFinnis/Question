//
//  Countdown.swift
//  Question
//
//  Created by Jack Finnis on 10/01/2022.
//

import SwiftUI

struct Countdown: View {
    @ObservedObject var questionVM: QuestionVM
    
    let haptics = HapticsHelper()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(questionVM.formattedTimeRemaining)
            .foregroundColor(questionVM.timeIntervalRemaining < 10.5 && questionVM.timeIntervalRemaining > 0 ? .red : .none)
            .onReceive(timer) { _ in
                questionVM.timeIntervalRemaining = questionVM.question?.end?.timeIntervalSinceNow ?? 0
                if questionVM.formattedTimeRemaining == "1" {
                    haptics.error()
                }
            }
    }
}
