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
            ZStack {
                Form { }
                Form {
                    Section {
                        TextField("Username", text: $authVM.createUsername)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .textContentType(.name)
                            .submitLabel(.join)
                            .onSubmit {
                                Task {
                                    await authVM.createAccount()
                                }
                            }
                    } footer: {
                        Text("Create a unique username. This username cannot be changed and is public")
                    }
                    
                    Section {
                        if authVM.loading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
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
                        }
                    } footer: {
                        Text(authVM.createUsernameError ?? "")
                    }
                }
                .frame(maxWidth: 700)
            }
            .navigationTitle("Sign Up")
        }
        .navigationViewStyle(.stack)
    }
}
