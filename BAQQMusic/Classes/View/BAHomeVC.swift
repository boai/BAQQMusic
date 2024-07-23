//
//  BAHomeVC.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/23.
//

import UIKit
import Foundation

class BAHomeVC: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "首页"
        view.backgroundColor = UIColor.white
        
        view.addSubview(musicDetailButton)
        musicDetailButton.snp.makeConstraints { make in
            make.center.equalToSuperview().offset(0)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        musicDetailButton.layer.cornerRadius = 25
        musicDetailButton.layer.masksToBounds = true
    }
    
    lazy var musicDetailButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Detail", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green.withAlphaComponent(0.1)
        button.addTarget(self, action: #selector(onDetail), for: .touchUpInside)
        
        return button
    }()
    
    @objc func onDetail() {
        let vc = BAMusicPlayVC2()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
}
