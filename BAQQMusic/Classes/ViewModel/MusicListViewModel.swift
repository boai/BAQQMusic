//
//  MusicListViewModel.swift
//  qqMusic
//
//  Created by Ann on 2017/9/21.
//  Copyright © 2017年 Ann. All rights reserved.
//

import Foundation

//2.4 创建储存数据列表ViewModel
class MusicListViewModel {

    var musicList: [MusicModel] = []
   
  //2.5 加载plist文件获取模型数组
    func loadMusicList(finished:(_ isSuccessed:Bool)->()){
    
        let filePath = Bundle.main.path(forResource: "Musics.plist", ofType: nil)
        guard (filePath != nil) else {
           finished(false)
            return
        }
        guard let arr = NSArray(contentsOfFile: filePath!) as? [[String:AnyObject]] else {
              finished(false)
            return
        }
        for dict in arr {
            
            do {
                // 将字典转换为Data
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
                // 使用JSONDecoder将Data转换为模型
                let music: MusicModel = try JSONDecoder().decode(MusicModel.self, from: jsonData)
                musicList.append(music)
                // 使用user模型
                print(music.name ?? "") // 输出: John Doe
            } catch {
                print(error)
            }
        }
        
        finished(true)
    }

}
