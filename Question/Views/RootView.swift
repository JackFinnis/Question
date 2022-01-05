//
//  RootView.swift
//  Question
//
//  Created by Jack Finnis on 22/10/2021.
//

import SwiftUI

struct RootView: View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        NavigationView {
            if vm.username == nil {
                SignUpView()
            } else if vm.joinUsername != nil {
                RoomView(username: vm.username!, joinUsername: vm.joinUsername!)
            } else {
                UserView(username: vm.username!)
            }
        }
        .environmentObject(vm)
    }
}
