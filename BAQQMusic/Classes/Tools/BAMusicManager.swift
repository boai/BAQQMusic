//
//  BAMusicManager.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/22.
//

import Foundation
import AVFoundation

class BAMusicManager: NSObject {
    static let shared = BAMusicManager()
    
    //数据源
    var musicList: [MusicModel] = []
    
    //是否正在播放
    var isPlaying: Bool {
        get {
            return player.isPlaying
        }
    }
    
    //当前播放的音乐
    var currentMusic: MusicModel = MusicModel()
    
    //当前播放的 index
    var currentIndex: Int = 0
    
    //进度条计时器
    var progressTimer :Timer?
    //更新进度条
    var onUpdageProgress: ((_ progress: Float) -> Void)?
    //更新歌词进度
    var onUpdageLrc: ((_ time: TimeInterval) -> Void)?
    
    //播放结束
    var onPlayEnd: ((_ music: MusicModel) -> Void)?

    
    //播放器
    private var player: AVAudioPlayer = AVAudioPlayer()
    
    private override init() {
        super.init()
        
        currentMusic = musicList.first ?? MusicModel()
        currentIndex = getIndexWithMusic(currentMusic)
        player.delegate = self
    }
    
}

//MARK: AVAudioPlayerDelegate
extension BAMusicManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            //播放结束
            print("当前歌曲播放完毕")
            onPlayEnd!(currentMusic)
        }
    }
}

//MARK: 播放器
extension BAMusicManager {
    
    //播放
    func play(_ music: MusicModel) -> Void {
        
        guard let pathUrl = Bundle.main.url(forResource: music.filename, withExtension: nil) else {
            print("没有找到歌曲：\(String(describing: music.filename))")
            return
        }
        
        if pathUrl == player.url {
            player.play()
            return
        }
        
        guard let musicTrue = try? AVAudioPlayer(contentsOf: pathUrl) else { return }
        player = musicTrue
        currentMusic = music
        player.play()
        
        //启动计时器
        addProgressTimer()
        print("当前歌曲开始播放")
    }
    
    //设置从指定时间开始播放
    func playWithTime(_ currentTime: TimeInterval) -> Void {
        player.currentTime = currentTime
    }
    
    //播放指定 index
    func playWithIndex(_ index: Int) -> Void {
        var index = currentIndex
        if index >= musicList.count {
            index = 0
        } else if (index <= 0) {
            index = 0
        }
        play(musicList[index])
    }
    
    //播放下一曲
    func playNext() -> Void {
        print("播放下一曲")
        //关闭计时器
        removeProgressTimer()
        play(musicList[currentIndex + 1])
    }
    
    //播放上一曲
    func playPre() -> Void {
        print("播放上一曲")
        //关闭计时器
        removeProgressTimer()
        play(musicList[currentIndex - 1])
    }
    
    //暂停
    func pause() -> Void {
        print("暂停播放")
        player.pause()
        
        //关闭计时器
        removeProgressTimer()
    }
    
    //停止
    func stop() -> Void {
        print("停止播放")
        player.stop()
        
        //关闭计时器
        removeProgressTimer()
    }
}

//MARK: 歌曲信息
extension BAMusicManager {
    
    //获取歌曲总长度
    func getDuration() -> TimeInterval {
        return player.duration
    }
    
    func getCurrentTime() -> TimeInterval {
        return player.currentTime
    }
    
    //根据 music 获取 index
    func getIndexWithMusic(_ music: MusicModel) -> Int {
        var index_new = currentIndex
        
        for (index, obj) in musicList.enumerated() {
            if obj.filename == music.filename {
                index_new = index
            }
        }
        return index_new
    }
    
}

//MARK: 歌词
extension BAMusicManager {
//    //添加计时器
//    func addLrcTimer() {
//        lrcTimer = CADisplayLink(target: self, selector: #selector(updateLrc))
//        lrcTimer?.add(to: RunLoop.main, forMode: .common)
//    }
//    
//    //移除计时器
//    func removeLrcTimer() {
//        lrcTimer?.invalidate()
//        lrcTimer = nil
//    }
//    
//    //更新歌词进度
//    @objc func updateLrc() {
//    }
}

//MARK: 进度条
extension BAMusicManager {
    //添加计时器
    func addProgressTimer() {
        progressTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        RunLoop.main.add(progressTimer!, forMode: .common)
    }
    
    //移除计时器
    func removeProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    //更新进度条进度
    @objc func updateProgress() {
        let progress = Float(getCurrentTime()/getDuration())
        onUpdageProgress!(progress)
        onUpdageLrc!(BAMusicManager.shared.getCurrentTime())
    }
}

//MARK: 加载数据
extension BAMusicManager {
    
    static func loadData(callback:(_ isSuccess:Bool) ->()) {
        let filePath = Bundle.main.path(forResource: "Musics.plist", ofType: nil)
        guard (filePath != nil) else {
            callback(false)
            return
        }
        guard let array = NSArray(contentsOfFile: filePath!) as? [[String:AnyObject]] else {
            callback(false)
            return
        }
        
        var temp:[MusicModel] = []
        for dict in array {
            do {
                // 将字典转换为Data
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
                // 使用JSONDecoder将Data转换为模型
                let music: MusicModel = try JSONDecoder().decode(MusicModel.self, from: jsonData)
                temp.append(music)
                // 使用user模型
                print(music.name ?? "") // 输出: John Doe
            } catch {
                print(error)
            }
        }
        BAMusicManager.shared.musicList = temp
        BAMusicManager.shared.currentIndex = 0
        BAMusicManager.shared.currentMusic = temp.first ?? MusicModel()
        callback(true)
    }
}
