//
//  ClipboardHelper.swift
//  Question
//
//  Created by Jack Finnis on 17/01/2022.
//

import UIKit

struct ClipboardHelper {
    let haptics = HapticsHelper()
    
    func copy(string: String) {
        let clipboard = UIPasteboard.general
        clipboard.string = string
        haptics.success()
    }
}
