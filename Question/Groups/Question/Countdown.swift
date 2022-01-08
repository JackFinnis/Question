//
//  Countdown.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct Countdown: View {
    @State var timeIntervalRemaining: TimeInterval?
    
    let question: Question
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var formattedTimeRemaining: String {
        if timeIntervalRemaining == nil {
            return ""
        } else if timeIntervalRemaining! > 0 {
            return "Finished"
        } else {
            return timeIntervalRemaining!.formatted()
        }
    }
    
    var body: some View {
        if question.end != nil && question.finished {
            Text(formattedTimeRemaining)
                .onReceive(timer) { _ in
                    timeIntervalRemaining = question.end?.timeIntervalSinceNow
                }
        }
    }
}
