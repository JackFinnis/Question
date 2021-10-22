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
        NavigationView {
            Form {
                Section(footer: Text(vm.errorMessage ?? "")) {
                    TextField("Username", text: $vm.username)
                        .disableAutocorrection(true)
                        .textContentType(.name)
                        .submitLabel(.join)
                    
                    Button("Sign Up") {
                        Task {
                            await vm.createAccount()
                        }
                    }
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
}
