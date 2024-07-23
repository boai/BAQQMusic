//
//  BAMusicPlayVC.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/22.
//

import UIKit
import Foundation
import SnapKit

class BAMusicPlayVC: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BAMusicManager.shared.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        initData()
    }
    
    func initUI() {
        view.addSubview(playView)
        playView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
       
    }
    
    func initData() {
        BAMusicManager.loadData { (isSuccess) in
            guard isSuccess else {
                print("数据加载异常，请检查数据")
                return
            }
            playView.onPlayOrPause()
        }
        //播放结束
        BAMusicManager.shared.onPlayEnd = { [weak self] music in
            guard let self = self else { return }
           
            print("当前歌曲播放完毕，自动播放下一首！")
            playView.onPlayNext()
        }
    }
         
    lazy var playView = {
        let view = BAMusicPlayView()
        
        //播放&暂停
        view.onPlayOrPauseMusic = { [weak self] in
            guard let self = self else { return }
            
            if BAMusicManager.shared.isPlaying {
                //暂停
                BAMusicManager.shared.pause()
                view.onPause()
            } else {
                //播放
                BAMusicManager.shared.play(BAMusicManager.shared.currentMusic)
                view.onPlay()
            }
        }
        
        view.onPlayNextMusic = { [weak self] in
            guard let self = self else { return }
            BAMusicManager.shared.playNext()
        }
        
        view.onPlayPreMusic = { [weak self] in
            guard let self = self else { return }
            BAMusicManager.shared.playPre()
        }
        
        return view
    }()
    
   
   
    
}

extension BAMusicPlayVC {
    
}
