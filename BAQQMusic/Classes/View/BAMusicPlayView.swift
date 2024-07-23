//
//  BAMusicPlayView.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/22.
//

import UIKit
import Foundation
import SnapKit

class BAMusicPlayView: UIView {
    
    //播放&暂停
    var onPlayOrPauseMusic: (() -> Void)?
    var onPlayNextMusic: (() -> Void)?
    var onPlayPreMusic: (() -> Void)?
    
    var rotationAnim:CABasicAnimation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        initData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initUI() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubview(blurBgView)
        blurBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubview(songNameLabel)
        songNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(88)
            make.centerX.equalTo(bgView.snp.centerX)
        }
        
        bgView.addSubview(singerLabel)
        singerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(songNameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(songNameLabel.snp.centerX)
        }
        
        bgView.addSubview(detailButton)
        detailButton.snp.makeConstraints { (m) in
            m.centerY.equalTo(songNameLabel.snp.centerY)
            m.right.equalTo(bgView.snp.right).offset(-5)
        }
        
        bgView.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(songNameLabel.snp.centerY)
            make.left.equalTo(bgView.snp.left).offset(5)
            make.height.width.equalTo(detailButton.snp.height)
        }
        
        bgView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (m) in
            m.width.height.equalTo(250)
            m.top.equalTo(songNameLabel.snp.bottom).offset(45)
            m.centerX.equalTo(bgView.snp.centerX)
        }
        bgImageView.layer.cornerRadius = CGFloat(125)
        bgImageView.layer.masksToBounds = true
        
        bgView.addSubview(trueImageView)
        trueImageView.snp.makeConstraints { (m) in
            m.width.height.equalTo(240)
            m.center.equalTo(bgImageView)
        }
        trueImageView.layer.cornerRadius = CGFloat(120)
        trueImageView.layer.masksToBounds = true
        
        
        bgView.addSubview(lrcLabel)
        lrcLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.bottom).offset(5)
            make.centerX.equalTo(bgImageView.snp.centerX)
            
        }
        
        bgView.addSubview(lrcLabelTwo)
        lrcLabelTwo.snp.makeConstraints { (make) in
            make.top.equalTo(lrcLabel.snp.bottom).offset(5)
            make.centerX.equalTo(lrcLabel.snp.centerX)
            
        }
        
        bgView.addSubview(playOrPauseButton)
        playOrPauseButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-(getSafeAreaInsets().bottom)-20)
            make.centerX.equalToSuperview()
        }
        
        bgView.addSubview(slider)
        bgView.addSubview(currentTimeLabel)
        currentTimeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(slider.snp.centerY)
        }
        
        bgView.addSubview(totalTimeLabel)
        totalTimeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(slider.snp.centerY)
        }
        
        bgView.addSubview(previousSongButton)
        previousSongButton.snp.makeConstraints { (make) in
            make.right.equalTo(playOrPauseButton.snp.left).offset(-20)
            make.centerY.equalTo(playOrPauseButton.snp.centerY)
            
        }
        
        bgView.addSubview(nextSongButton)
        nextSongButton.snp.makeConstraints { (make) in
            make.left.equalTo(playOrPauseButton.snp.right).offset(20)
            make.centerY.equalTo(playOrPauseButton.snp.centerY)
        }
        
        slider.snp.makeConstraints { (make) in
            make.top.equalTo(playOrPauseButton.snp.top).offset(-40)
            make.left.equalTo(currentTimeLabel.snp.right).offset(10)
            make.right.equalTo(totalTimeLabel.snp.left).offset(-10)
            make.height.equalTo(4)
        }
        
    }
    
    func initData() {
        //更新进度条
        BAMusicManager.shared.onUpdageProgress = { [weak self] progress in
            guard let self = self else { return }
            
            let currentTime = BAMusicManager.shared.getCurrentTime().stringByTime()
            let totalTime = BAMusicManager.shared.getDuration().stringByTime()

            
            print("当前播放进度：（\(currentTime)/\(totalTime)），progress：\(progress)")
            if progress >= 1 {
                print("当前歌曲播放完毕，自动播放下一首！")
                onPlayNext()
            } else {
                currentTimeLabel.text = BAMusicManager.shared.getCurrentTime().stringByTime()
                slider.value = progress
            }
        }
        
        //更新歌词进度
        BAMusicManager.shared.onUpdageLrc = { [weak self] time in
            guard let self = self else { return }
            
        }
        
    }
    
    //MARK: - method
    
    func updateData(_ music: MusicModel) {
        //歌曲界面信息
        songNameLabel.text = music.name
        singerLabel.text = music.singer
        trueImageView.image = UIImage(named: music.icon ?? "")
        
        //将时间格式化再赋值
        currentTimeLabel.text = BAMusicManager.shared.getCurrentTime().stringByTime()
        totalTimeLabel.text = BAMusicManager.shared.getDuration().stringByTime()
    }
    
    @objc func onPlayOrPause() {
        currentTimeLabel.text = BAMusicManager.shared.getCurrentTime().stringByTime()
        onPlayOrPauseMusic!()
    }
    
    @objc func onPlayNext() {
        //        currentTimeLabel.text = "00:00"
        slider.value = 0
        onPlayNextMusic!()
        onPlay()
    }
    
    @objc func onPlayPre() {
        //        currentTimeLabel.text = "00:00"
        slider.value = 0
        onPlayPreMusic!()
        onPlay()
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
        updateProgress()
    }
    
    @objc func sliderTouchUpInside() {
        updateProgress()
    }
    
    @objc func sliderTouchUpOutside() {
        updateProgress()
    }
    
    @objc func sliderTouchDown() {
        updateProgress()
    }
    
    //重置播放位置
    func updateProgress() {
        
        let time = Double(slider.value) * BAMusicManager.shared.getDuration()
        //从当前百分比播放
        BAMusicManager.shared.playWithTime(time)
        //将时间格式化再赋值
        currentTimeLabel.text = BAMusicManager.shared.getCurrentTime().stringByTime()
    }
    
    //MARK: - lazy
    
    lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = .white//.withAlphaComponent(0.1)
        
        return view
    }()
    
    //左上关闭按钮
    lazy var closeButton:UIButton = {
        
        let b = UIButton()
        b.setImage(UIImage.init(named: "miniplayer_btn_playlist_close"), for: .normal)
        return b
        
    }()
    
    //右上曲目细节按钮
    lazy var detailButton:UIButton = {
        
        let b = UIButton()
        b.setImage(UIImage.init(named: "main_tab_more_h"), for: .normal)
        b.tintColor = UIColor.darkGray
        b.sizeToFit()
        return b
    }()
    
    //顶部歌名
    lazy var songNameLabel:UILabel = {
        
        let lab = UILabel()
        lab.textColor = UIColor.white
        lab.text = "歌曲名称"
        lab.sizeToFit()
        return lab
    }()
    
    //歌手名
    lazy var singerLabel:UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.lightGray
        lab.text = "歌手"
        lab.sizeToFit()
        return lab
    }()
    
    //CD圆盘边框图层
    lazy var bgImageView:UIImageView = {
        let bgV = UIImageView()
        bgV.backgroundColor = UIColor.darkGray
        return bgV
    }()
    
    //专辑图片
    lazy var trueImageView:UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.red
        imgV.image = UIImage.init(named: "ddd")
        
        return imgV
    }()
    
    //歌词文本
    lazy var lrcLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.text = ""
        return lb
    }()
    
    //歌词文本
    lazy var lrcLabelTwo:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.text = ""
        return lb
    }()
    
    //曲目进度条
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.minimumTrackTintColor = UIColor.init(red: 51/255, green: 194/255, blue: 124/255, alpha: 1)
        slider.thumbTintColor =  UIColor.init(red: 51/255, green: 194/255, blue: 124/255, alpha: 1)
        
        //监听进度条各个事件
        slider.addTarget(self, action: #selector(sliderValueChanged(slider:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchUpInside), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOutside), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchDown), for: .touchDown)
        
        return slider
    }()
    
    //曲目进度时间
    lazy var currentTimeLabel:UILabel = {
        
        let lb = UILabel()
        lb.text = "00:00"
        lb.textColor = UIColor.white
        lb.font = UIFont.systemFont(ofSize: 10)
        lb.sizeToFit()
        return lb
    }()
    
    //曲目时长
    lazy var totalTimeLabel:UILabel = {
        
        let lb = UILabel()
        lb.text = "00:00"
        lb.textColor = UIColor.white
        lb.font = UIFont.systemFont(ofSize: 10)
        lb.sizeToFit()
        return lb
    }()
    
    //上一首按钮
    lazy var previousSongButton:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "player_btn_pre_normal"), for: .normal)
        btn.addTarget(self, action: #selector(onPlayPre), for:  .touchUpInside)
        
        return btn
    }()
    
    //下一首按钮
    lazy var nextSongButton:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "player_btn_next_normal"), for: .normal)
        btn.addTarget(self, action: #selector(onPlayNext), for: .touchUpInside)
        
        return btn
    }()
    
    //播放/暂停 按钮
    lazy var playOrPauseButton:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "player_btn_play_normal"), for: .normal)
        btn.sizeToFit()
        
        btn.addTarget(self, action: #selector(onPlayOrPause), for: .touchUpInside)
        return btn
    }()
    
    //蒙版背景/毛玻璃背景
    lazy var blurBgView = {
        let view = UIImageView(image: UIImage(named: "ddd"))
        view.isUserInteractionEnabled = true
        
        //对歌手背景视图的毛玻璃化处理//找张图片顶替看预设效果
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(blurView)
        
        return view
    }()
}

extension BAMusicPlayView {
    //播放
    func onPlay() {
        playOrPauseButton.setImage(UIImage.init(named: "player_btn_pause_normal"), for: .normal)
        //继续动画旋转
        trueImageView.layer.resumeAnim()
        
        if rotationAnim == nil {
            addRotationAnim()
        }
        updateData(BAMusicManager.shared.currentMusic)
    }
    
    //暂停
    func onPause() {
        playOrPauseButton.setImage(UIImage.init(named: "player_btn_play_normal"), for: .normal)
        //暂停动画旋转
        trueImageView.layer.pauseAnim()
    }
    
    //旋转动画
    func addRotationAnim() {
        rotationAnim = CABasicAnimation(keyPath: kKeyPath_PlayerRotation)
        rotationAnim?.fromValue = 0
        rotationAnim?.toValue = Double.pi * 2
        rotationAnim?.repeatCount = MAXFLOAT
        rotationAnim?.duration = 30
        rotationAnim?.isRemovedOnCompletion = false
        
        guard let ani = rotationAnim else { return }
        trueImageView.layer.add(ani, forKey: "trueImageView")
    }
}
