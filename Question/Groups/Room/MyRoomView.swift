//
//  MyRoomView.swift
//  Question
//
//  Created by Jack Finnis on 05/01/2022.
//

import SwiftUI

struct MyRoomView: View {
    @StateObject var roomVM = RoomVM()
    
    let username: String
    
    var body: some View {
        Text("My Room")
    }
}
