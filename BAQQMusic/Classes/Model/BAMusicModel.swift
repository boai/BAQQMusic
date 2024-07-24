//
//  BAMusicModel.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/23.
//


import UIKit

class BAMusicModel: Codable, Equatable {
    static func == (lhs: BAMusicModel, rhs: BAMusicModel) -> Bool {
        return true
    }
    
    var name:String?
    var filename:String?
    var lrcname:String?
    var singer:String?
    var singerIcon:String?
    var icon:String?
   
}
