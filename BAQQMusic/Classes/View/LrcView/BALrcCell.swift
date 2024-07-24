//
//  BALrcCell.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/23.
//


import UIKit

class BALrcCell: UITableViewCell {
    
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

extension BALrcCell {
    
    func updateLine(lrcModel: BALrcLineModel, isCurrent: Bool) -> Void {
        if isCurrent {
            lrcLabel.font = UIFont.systemFont(ofSize: 17.0)
            lrcLabel.textColor = UIColor.green
        } else {
            lrcLabel.textColor = UIColor.gray
            lrcLabel.font = UIFont.systemFont(ofSize: 14.0)
        }
        lrcLabel.text = lrcModel.lrcText
    }
    
}
