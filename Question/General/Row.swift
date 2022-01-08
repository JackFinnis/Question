//
//  Row.swift
//  Question
//
//  Created by Jack Finnis on 05/01/2022.
//

import SwiftUI

struct Row: View {
    let leading: String
    let trailing: String
    
    var body: some View {
        HStack {
            Text(leading)
            Spacer()
            Text(trailing)
                .font(.none)
                .foregroundColor(.secondary)
        }
    }
}
