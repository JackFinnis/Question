//
//  HapticsHelper.swift
//  Ecommunity
//
//  Created by Jack Finnis on 11/12/2021.
//

import Foundation
#if !os(macOS)
    import UIKit
#endif

struct HapticsHelper {
    // MARK: - Properties
    #if !os(macOS)
        let generator = UINotificationFeedbackGenerator()
    #endif
    
    // MARK: - Methods
    func success() {
        #if !os(macOS)
            generator.notificationOccurred(.success)
        #endif
    }
    
    func error() {
        #if !os(macOS)
            generator.notificationOccurred(.success)
        #endif
    }
}
