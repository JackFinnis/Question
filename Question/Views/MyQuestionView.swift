//
//  MyQuestionView.swift
//  Question
//
//  Created by Jack Finnis on 24/10/2021.
//

import SwiftUI

struct MyQuestionView: View {
    @EnvironmentObject var vm: ViewModel
    
    let username: String
    let questionID: String
    
    var body: some View {
        Text("Hello, World!")
    }
}
