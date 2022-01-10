//
//  View.swift
//  Question
//
//  Created by Jack Finnis on 10/01/2022.
//

import SwiftUI

extension View {
    func centred() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
}
