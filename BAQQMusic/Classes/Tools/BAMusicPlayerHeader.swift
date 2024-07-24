//
//  BAMusicPlayerHeader.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/23.
//

import UIKit
import Foundation


/// 屏幕宽高
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height


public func getCurrentWindow()->UIWindow? {
    var window = UIApplication.shared.delegate?.window
    if #available(iOS 13.0, *) {
        window = UIApplication.shared.connectedScenes
                 .filter({$0.activationState == .foregroundActive})
                 .map({$0 as? UIWindowScene})
                 .compactMap({$0})
                 .first?.windows
                 .filter({$0.isKeyWindow}).first
    }
    return window ?? nil
}

public func getSafeAreaInsets()->UIEdgeInsets {
    return getCurrentWindow()?.safeAreaInsets ?? UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
}


let kKeyPath_PlayerRotation = "transform.rotation.z"
