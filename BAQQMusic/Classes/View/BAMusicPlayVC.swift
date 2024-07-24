//
//  BAMusicPlayVC.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/23.
//

import UIKit
import Foundation
import AVFAudio

class BAMusicPlayVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        initData()
        initApi()
    }
    
    func initUI() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(playView)
        playView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT)
        }
        
        scrollView.addSubview(lrcView)
        lrcView.snp.makeConstraints { make in
            make.left.equalTo(playView.snp.right).offset(0)
            make.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 2, height: SCREEN_HEIGHT)
    }
    
    func initData() {
        
    }
    
    func initApi() -> Void {
        //加载数据
        loadData { result in
            guard result else {
                print("数据加载异常，请检查数据")
                return
            }
            
            playView.onPlayOrPause()
            BAAudioPlayer.shared.player.delegate = self
        }
    }
    
    lazy var playView = {
        let view = BAMusicPlayView()
        
        view.onBackBlock = { [weak self] in
            guard let self = self else { return }
            
            BAAudioPlayer.shared.stop()
            self.dismiss(animated: true)
        }
        return view
    }()
    
    lazy var lrcView = {
        let view = BALrcView()
        
        return view
    }()
    
    lazy var scrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.delegate = self
        scrollView.backgroundColor = .yellow.withAlphaComponent(0.1)
        
        return scrollView
    }()
    
}

extension BAMusicPlayVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset_X = scrollView.contentOffset.x;
        let currentPage = ceil(offset_X/SCREEN_WIDTH)
        print("当前页面：\(currentPage)")
        
    }
}

//MARK: AVAudioPlayerDelegate
extension BAMusicPlayVC: AVAudioPlayerDelegate {
    //播放器播放完毕后就会调用该方法
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            //播放结束
            print("当前歌曲播放完毕")
            playView.onPlayNext()
        }
    }
    
    //当播放器遇到中断的时候（如来电），调用该方法
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        playView.onPlayOrPause()
    }
    
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        
    }
}

//MARK: 加载数据
extension BAMusicPlayVC {
    func loadData(callback:(_ result:Bool) ->()) {
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
        BAAudioPlayer.shared.musicList = temp
        BAAudioPlayer.shared.currentIndex = 0
        BAAudioPlayer.shared.currentMusic = temp.first ?? MusicModel()
        callback(true)
    }
}
