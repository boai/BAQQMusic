//
//  BALrcView.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/23.
//

import UIKit
import Foundation

class BALrcView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        initData()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() -> Void {
        self.backgroundColor = .orange.withAlphaComponent(0.1)
    }
    
    func initData() -> Void {
        
    }
    
    
}
