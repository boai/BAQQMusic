//
//  LrclineModel.swift
//  qqMusic
//
//  Created by Ann on 2017/9/21.
//  Copyright © 2017年 Ann. All rights reserved.
//

import Foundation
class LrclineModel: NSObject {
    //一句歌词
    var lrcText:String?
    //一句歌词对于时间
    var lrcTime:TimeInterval = 0
    
    init(lrcLineStr:String) {
        // [00:35.89]你所有承诺　虽然都太脆弱
        let str0 = lrcLineStr.components(separatedBy: "]")
        
        lrcText = str0[1]
        
        //时间解析
        //[00:35.89
        let str1 = str0[0].components(separatedBy: "[")
        //00:35.89
        let str2 = str1[1]
        let str3 = str2.components(separatedBy: ":")
        //
        let minute =  Double(str3[0])
        
        let second = Double(str3[1].components(separatedBy: ".")[0])
        
        let ms = Double(str3[1].components(separatedBy: ".")[1])
        
        let timeSecond = minute! * 60 + second! + ms! * 0.01
        lrcTime = timeSecond
        
    }
    
}
