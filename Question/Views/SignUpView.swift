//
//  SignUpView.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $vm.createUsername)
                    .disableAutocorrection(true)
                    .textContentType(.name)
                    .submitLabel(.join)
            } footer: {
                Text("This username cannot be changed and is public")
            }
            
            Section {
                Button {
                    Task {
                        await vm.createAccount()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Sign Up")
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .listRowBackground(Color.accentColor)
            } footer: {
                Text(vm.createUsernameError ?? "")
            }
        }
        .navigationTitle("Sign Up")
        .onSubmit {
            Task {
                await vm.createAccount()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                if vm.loading {
                    ProgressView()
                }
            }
        }
    }
}
