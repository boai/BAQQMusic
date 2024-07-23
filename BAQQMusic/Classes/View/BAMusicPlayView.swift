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
            
    var onBackBlock: (() -> Void)?
    
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
        
        layoutUI()
        
    }
        
    func initData() {
        //更新进度条
        BAAudioPlayer.shared.onUpdageProgress = { [weak self] progress in
            guard let self = self else { return }
            
            let currentTime = BAAudioPlayer.shared.getCurrentTime().stringByTime()
            let totalTime = BAAudioPlayer.shared.getDuration().stringByTime()

//            print("当前播放进度：（\(currentTime)/\(totalTime)），progress：\(progress)")
            if progress >= 1 {
                print("当前歌曲播放完毕，自动播放下一首！")
                onPlayNext()
            } else {
                DispatchQueue.main.async {
                    self.currentTimeLabel.text = BAAudioPlayer.shared.getCurrentTime().stringByTime()
                    self.slider.value = progress
                }
            }
        }
        
        //更新歌词进度
        BAAudioPlayer.shared.onUpdageLrc = { [weak self] time in
            guard let self = self else { return }
            
        }
    }
    
    
    //MARK: - lazy
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white//.withAlphaComponent(0.1)
        
        return view
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
        
    lazy var naviView: UIView = {
        let view = UIView()
//        view.backgroundColor = .yellow//.withAlphaComponent(0.1)
        
        return view
    }()
    //关闭按钮
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.init(named: "miniplayer_btn_playlist_close"), for: .normal)
        button.addTarget(self, action: #selector(onBack), for:  .touchUpInside)

        return button
    }()
    lazy var detailButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.init(named: "main_tab_more_h"), for: .normal)
        button.tintColor = UIColor.darkGray
        button.sizeToFit()
        
        return button
    }()
    lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "歌曲名称"
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    lazy var infoView: UIView = {
        let view = UIView()
//        view.backgroundColor = .yellow//.withAlphaComponent(0.1)
        
        return view
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
    lazy var musicImageView:UIImageView = {
        let bgV = UIImageView()
        bgV.backgroundColor = UIColor.darkGray
        return bgV
    }()
    //专辑图片
    lazy var trueImageView:UIImageView = {
        let imgV = UIImageView()
//        imgV.backgroundColor = UIColor.red
        imgV.image = UIImage.init(named: "ddd")
        
        return imgV
    }()
    
    lazy var lrcView: UIView = {
        let view = UIView()
//        view.backgroundColor = .yellow//.withAlphaComponent(0.1)
        
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
//        view.backgroundColor = .yellow//.withAlphaComponent(0.1)
        
        return view
    }()
    //曲目进度时间
    lazy var currentTimeLabel: UILabel = {
        
        let lb = UILabel()
        lb.text = "00:00"
        lb.textColor = UIColor.white
        lb.font = UIFont.systemFont(ofSize: 10)
        lb.sizeToFit()
        return lb
    }()
    
    //曲目时长
    lazy var totalTimeLabel: UILabel = {
        
        let lb = UILabel()
        lb.text = "00:00"
        lb.textColor = UIColor.white
        lb.font = UIFont.systemFont(ofSize: 10)
        lb.sizeToFit()
        return lb
    }()
    
    //上一首按钮
    lazy var previousSongButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "player_btn_pre_normal"), for: .normal)
        btn.addTarget(self, action: #selector(onPlayPre), for:  .touchUpInside)
        
        return btn
    }()
    
    //下一首按钮
    lazy var nextSongButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "player_btn_next_normal"), for: .normal)
        btn.addTarget(self, action: #selector(onPlayNext), for: .touchUpInside)
        
        return btn
    }()
    
    //播放/暂停 按钮
    lazy var playOrPauseButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "player_btn_play_normal"), for: .normal)
        btn.sizeToFit()
        
        btn.addTarget(self, action: #selector(onPlayOrPause), for: .touchUpInside)
        return btn
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
}

extension BAMusicPlayView {
    //歌曲界面信息
    func updateData(_ music: MusicModel) {
        songNameLabel.text = music.name
        singerLabel.text = music.singer
        trueImageView.image = UIImage(named: music.icon ?? "")

        updateTime()
    }
    
    //更新时间
    func updateTime() {
        currentTimeLabel.text = BAAudioPlayer.shared.getCurrentTime().stringByTime()
        totalTimeLabel.text = BAAudioPlayer.shared.getDuration().stringByTime()
    }
    
    @objc func onBack() {
        onBackBlock!()
    }
}

//MARK: 播放器
extension BAMusicPlayView {
    
    @objc func onPlayOrPause() {
        play(isPlaying: BAAudioPlayer.shared.player.isPlaying)
    }
    
    func play(isPlaying: Bool) {
        if isPlaying {
            //暂停
            playOrPauseButton.setImage(UIImage.init(named: "player_btn_play_normal"), for: .normal)
            
            //暂停动画旋转
            trueImageView.layer.pauseAnim()
            BAAudioPlayer.shared.pause()
        } else {
            //播放
            playOrPauseButton.setImage(UIImage.init(named: "player_btn_pause_normal"), for: .normal)

            //继续动画旋转
            trueImageView.layer.resumeAnim()
            if rotationAnim == nil {
                addRotationAnim()
            }
            
            BAAudioPlayer.shared.play(BAAudioPlayer.shared.currentMusic)
            updateData(BAAudioPlayer.shared.currentMusic)
        }
    }
    
    @objc func onPlayNext() {
        play(isPlaying: false)
        slider.value = 0
        
        var index = BAAudioPlayer.shared.currentIndex + 1
        if index >= BAAudioPlayer.shared.musicList.count - 1 {
            index = 0
        }
        BAAudioPlayer.shared.currentIndex = index
        BAAudioPlayer.shared.play(BAAudioPlayer.shared.musicList[index])
        updateData(BAAudioPlayer.shared.currentMusic)
    }
    
    @objc func onPlayPre() {
        play(isPlaying: false)
        slider.value = 0
        
        var index = BAAudioPlayer.shared.currentIndex - 1
        if index <= 0 {
            index = BAAudioPlayer.shared.musicList.count - 1
        }
        
        BAAudioPlayer.shared.currentIndex = index
        BAAudioPlayer.shared.play(BAAudioPlayer.shared.musicList[index])
        updateData(BAAudioPlayer.shared.currentMusic)
    }
    
    @objc func onUpdateLrc() {
        
    }
    
    @objc func updateProgress() {
        let time = Double(slider.value) * BAAudioPlayer.shared.getDuration()
        //从当前百分比播放
        BAAudioPlayer.shared.playWithTime(time)
        updateTime()
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
    
}

//MARK: UI
extension BAMusicPlayView {
    
    func layoutUI() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgView.addSubview(blurBgView)
        blurBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubview(naviView)
        naviView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(getSafeAreaInsets().top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        naviView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        naviView.addSubview(detailButton)
        detailButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        naviView.addSubview(songNameLabel)
        songNameLabel.snp.makeConstraints { make in
            make.left.equalTo(closeButton.snp.right).offset(16)
            make.right.equalTo(detailButton.snp.left).offset(-16)
            make.center.equalToSuperview()
        }
        
        bgView.addSubview(bottomView)
        bgView.addSubview(lrcView)
        lrcView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top).offset(-10)
            make.height.equalTo(80)
        }
        
        bgView.addSubview(infoView)
        infoView.snp.makeConstraints { (make) in
            make.top.equalTo(naviView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(lrcView.snp.top).offset(-10)
        }
        infoView.addSubview(singerLabel)
        singerLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        infoView.addSubview(musicImageView)
        musicImageView.snp.makeConstraints { make in
            make.width.height.equalTo(250)
            make.top.equalTo(singerLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        musicImageView.layer.cornerRadius = CGFloat(125)
        musicImageView.layer.masksToBounds = true
        
        infoView.addSubview(trueImageView)
        trueImageView.snp.makeConstraints { make in
            make.width.height.equalTo(240)
            make.center.equalTo(musicImageView)
        }
        trueImageView.layer.cornerRadius = CGFloat(120)
        trueImageView.layer.masksToBounds = true
        
        bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(getSafeAreaInsets().bottom + 20))
            make.left.right.equalToSuperview()
            make.height.equalTo(140)
        }
        
        bottomView.addSubview(playOrPauseButton)
        playOrPauseButton.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.width.height.equalTo(64)
        }
        bottomView.addSubview(nextSongButton)
        nextSongButton.snp.makeConstraints { make in
            make.left.equalTo(playOrPauseButton.snp.right).offset(20)
            make.centerY.equalTo(playOrPauseButton)
            make.width.height.equalTo(44)
        }
        bottomView.addSubview(previousSongButton)
        previousSongButton.snp.makeConstraints { make in
            make.right.equalTo(playOrPauseButton.snp.left).offset(-20)
            make.centerY.width.height.equalTo(nextSongButton)
        }
        bottomView.addSubview(currentTimeLabel)
        bottomView.addSubview(totalTimeLabel)
        bottomView.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(currentTimeLabel.snp.right).offset(10)
            make.right.equalTo(totalTimeLabel.snp.left).offset(-10)
            make.height.equalTo(4)
        }
        totalTimeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(slider.snp.centerY)
        }
        currentTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(slider.snp.centerY)
        }
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
