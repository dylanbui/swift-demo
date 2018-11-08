//
//  Pz.swift
//  SwiftApp
//
//  Created by Dylan Bui on 8/1/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import SwiftMessages

public enum Pz { }

// MARK: - Device functions
// MARK: -

extension Pz // => Device functions
{
    static func showErrorNetwork() -> Void {
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        
        let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
        warning.configureContent(title: "Warning", body: "Network don't connected.", iconText: iconText)
        warning.button?.isHidden = true
        let warningConfig = SwiftMessages.defaultConfig
        // warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
    }
}
