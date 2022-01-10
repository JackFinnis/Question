//
//  SignUpView.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var authVM: AuthVM
    @FocusState var focused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Form { }
                Form {
                    Section {
                        TextField("Username", text: $authVM.createUsername)
                            .textInputAutocapitalization(.words)
                            .disableAutocorrection(true)
                            .textContentType(.name)
                            .submitLabel(.join)
                            .focused($focused)
                            .onSubmit {
                                Task {
                                    await authVM.createAccount()
                                }
                            }
                    } footer: {
                        Text("Create a unique username. This username cannot be changed and is public.")
                    }
                    
                    Section {
                        if authVM.loading {
                            ProgressView()
                                .centred()
                        } else {
                            Button("Sign Up") {
                                Task {
                                    await authVM.createAccount()
                                }
                            }
                            .centred()
                            .foregroundColor(.white)
                            .listRowBackground(Color.accentColor)
                        }
                    } footer: {
                        Text(authVM.createUsernameError ?? "")
                    }
                }
                .frame(maxWidth: 700)
            }
            .navigationTitle("Sign Up")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focused = false
                    }
                }
            }
        }
    }
}
