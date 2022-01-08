//
//  SignUpView.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var authVM: AuthVM
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Username", text: $authVM.createUsername)
                        .disableAutocorrection(true)
                        .textContentType(.name)
                        .submitLabel(.join)
                        .onSubmit {
                            Task {
                                await authVM.createAccount()
                            }
                        }
                } footer: {
                    Text("This username cannot be changed and is public")
                }
                
                Section {
                    Button {
                        Task {
                            await authVM.createAccount()
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
                    Text(authVM.createUsernameError ?? "")
                }
            }
            .navigationTitle("Sign Up")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if authVM.loading {
                        ProgressView()
                    }
                }
            }
        }
    }
}
