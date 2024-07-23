//
//  MusicModel.swift
//  qqMusic
//
//  Created by Ann on 2017/9/21.
//  Copyright © 2017年 Ann. All rights reserved.
//

import UIKit

//2.2为plist文件创建歌曲模型MusicModel
class MusicModel: Codable, Equatable {
    static func == (lhs: MusicModel, rhs: MusicModel) -> Bool {
        return true
    }
    
    
    var name:String?
    var filename:String?
    var lrcname:String?
    var singer:String?
    var singerIcon:String?
    var icon:String?
    
    
//    init(dict:[String:AnyObject]) {
//        
//        super.init()
//        self.setValuesForKeys(dict)
//    }
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        
//    }
//    override var description: String{
//        let keys = ["name","filename","lrcname","singer","singerIcon","icon"]
//        return dictionaryWithValues(forKeys: keys).description
//    }
}
