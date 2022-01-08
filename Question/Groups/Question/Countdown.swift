//
//  Countdown.swift
//  Question
//
//  Created by Jack Finnis on 08/01/2022.
//

import SwiftUI

struct Countdown: View {
    @State var timeIntervalRemaining: TimeInterval
    
    let question: Question
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var formattedTimeRemaining: String {
        if question.end == nil {
            return "Live"
        } else if timeIntervalRemaining < 0 {
            return "Finished"
        } else {
            return DateComponentsFormatter().string(from: timeIntervalRemaining)!
        }
    }
    
    var body: some View {
        Text(formattedTimeRemaining)
            .onReceive(timer) { _ in
                timeIntervalRemaining = question.end?.timeIntervalSinceNow ?? 0
            }
    }
}
