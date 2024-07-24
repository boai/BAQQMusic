//
//  TimeIntervalExtension.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/23.
//

import Foundation

extension TimeInterval {
    //时间格式化
    func stringByTime()-> String {
        let min = Int(self) / 60
        let second = Int(self) % 60
        
        return String(format: "%02d:%02d", min, second)
    }
}
