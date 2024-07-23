//
//  LrcViewCell.swift
//  qqMusic
//
//  Created by Ann on 2017/9/21.
//  Copyright © 2017年 Ann. All rights reserved.
//


import UIKit

class LrcViewCell: UITableViewCell {
    
    lazy var lrcLabel:UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(lrcLabel)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        lrcLabel.textColor = UIColor.red
        lrcLabel.font = UIFont.systemFont(ofSize: 14)
        lrcLabel.textAlignment = .center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        lrcLabel.sizeToFit()
        lrcLabel.center = contentView.center
    }
}
