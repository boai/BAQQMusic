//
//  CALayerExtension.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/23.
//


import UIKit

extension CALayer {
    func pauseAnim() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }
    
    func resumeAnim() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let currentTime = convertTime(CACurrentMediaTime(), from: nil)
        beginTime = currentTime - pausedTime
    }
}
