//
//  Extension+TimeInterval.swift
//  qqMusic
//
//  Created by Ann on 2017/9/21.
//  Copyright © 2017年 Ann. All rights reserved.
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
