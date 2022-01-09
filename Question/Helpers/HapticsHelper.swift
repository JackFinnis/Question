//
//  HapticsHelper.swift
//  Ecommunity
//
//  Created by Jack Finnis on 11/12/2021.
//

import Foundation
import UIKit

struct HapticsHelper {
    // MARK: - Properties
    let generator = UINotificationFeedbackGenerator()
    
    // MARK: - Methods
    func success() {
        generator.notificationOccurred(.success)
    }
    
    func error() {
        generator.notificationOccurred(.error)
    }
}
