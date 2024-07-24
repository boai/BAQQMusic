//
//  BALrcTool.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/23.
//

import Foundation
class BALrcTool{
    //通过文件名解析歌词为每句歌词 BALrcLineModel 模型
    static func parseLrc(lrcFileName :String)-> [BALrcLineModel]?{
        guard let filePath = Bundle.main.path(forResource: lrcFileName, ofType: nil) else {
            return nil
        }
        guard let lrc = try? String(contentsOfFile: filePath) else{
            return nil
        }
        var temp = [BALrcLineModel]()
        //装载行歌词数组
        let lrcStringBylinesArr = lrc.components(separatedBy: "\n")
        
        // 每一行歌唱
        for lrcStringByline in lrcStringBylinesArr {
            if lrcStringByline.contains("[ti:") ||
                lrcStringByline.contains("[ar:") ||
                lrcStringByline.contains("[al:") ||
                !lrcStringByline.contains("[") {
                continue
            }
            //将每行转换为模型
            temp.append(BALrcLineModel(lrcLineStr: lrcStringByline))
        }
        return temp
    }
}
