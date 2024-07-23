//
//  LrcTools.swift
//  qqMusic
//
//  Created by Ann on 2017/9/21.
//  Copyright © 2017年 Ann. All rights reserved.
//


import Foundation
class LrcTools{
    //6.6.1通过文件名解析歌词为每句歌词LrclineModel模型
    class func parseLrc (lrcName :String)-> [LrclineModel]?{
        
        guard let filePath = Bundle.main.path(forResource: lrcName, ofType: nil) else {
            return nil
        }
        guard let lrc = try? String(contentsOfFile: filePath) else{
            return nil
        }
        var lrcModelArr = [LrclineModel]()
        //装载行歌词数组
        let lrcStringBylinesArr = lrc.components(separatedBy: "\n")
        
        // 每一行歌唱
        for lrcStringByline in lrcStringBylinesArr {
            
            if lrcStringByline.contains("[ti:") || lrcStringByline.contains("[ar:") || lrcStringByline.contains("[al:") || !lrcStringByline.contains("[") {
                continue
            }
            //将每行转换为模型
            
            lrcModelArr.append(LrclineModel(lrcLineStr: lrcStringByline))
            
            
        }
        
        return lrcModelArr
    }
    
}
