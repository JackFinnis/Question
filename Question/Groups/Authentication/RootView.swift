//
//  AuthView.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import SwiftUI

struct AuthView: View {
    @StateObject var authVM = AuthVM()
    
    var body: some View {
        Group {
            if authVM.username == nil {
                SignUpView(authVM: authVM)
            } else {
                UserView(username: authVM.username!)
            }
        }
    }
}
