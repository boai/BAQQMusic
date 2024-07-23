//
//  LrcScrollView.swift
//  qqMusic
//
//  Created by Ann on 2017/9/21.
//  Copyright © 2017年 Ann. All rights reserved.
//


import UIKit
let lrcCellID = "lrcCellID"
protocol LrcScrollViewDelegate : AnyObject {
     
    func lrcScrollView(lrcScrollView : LrcScrollView, nextLrcText : String, currentLrcText : String,  preLrcText : String)
}
class LrcScrollView: UIScrollView {
    //6.5.1内部属性，创建tableView
    lazy var tableView : UITableView = UITableView()
    var currentLineIndex : Int = 0
    //对外属性
    weak var lrcDelegate : LrcScrollViewDelegate?
    

    //6.6 创建解析歌词文件工具LrcTools，和每行歌词的模型LrclineModel
    
    //6.7 对外属性，传入当前播放的歌曲的歌词文件名
    var lrcname:String? {
        didSet {
            tableView.setContentOffset(CGPoint(x: 0, y: -bounds.height * 0.5), animated: false)
            guard lrcname != nil else {
                return
            }
            //6.8 解析歌词文件
            lrclines = LrcTools.parseLrc(lrcName: lrcname!)
            
            tableView.reloadData()
            
        }
    }

    
    //6.8.1 歌词数组
    var lrclines : [LrclineModel]?
    
 
    var currentTime:TimeInterval = 0 {
        didSet{
            guard let lrclines = lrclines else {
                return
            }
            
            let count = lrclines.count
            
            //7.2 获取当前播放到那句歌词
            for i in 0..<count{
                //当前句歌词
                let currentLrcline = lrclines[i]
                
                //下一句歌词
                let nextIndex = i + 1
                if nextIndex > count - 1 {
                    continue
                }
                let nextLrcline = lrclines[nextIndex]
                
                // 取得当前两句歌词之间的时间
                
                if currentTime >= currentLrcline.lrcTime  && currentTime < nextLrcline.lrcTime  {
                    
                    if (i == currentLineIndex){
                        return
                    }
                    //7.2.1 用全局变量标记正播放的下标
                    currentLineIndex = i
                    
                    // 取出当前i位置对应的indexPath
                    let indexPath = IndexPath(row: i, section: 0)
                    let preIndexPath = IndexPath(row: max(0, i - 1), section: 0)
                    
                   //7.2.2 刷新正在播放的歌词与前一句
                    tableView.reloadRows(at: [indexPath,preIndexPath], with: .none)
                    
                    tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                    
                    //7.7 歌词label显示实现
                     currentlineLrcAndNextLineLrc()
                }
            }
        }
        
    }
    func setupUI() {
        addSubview(tableView)
        
        
        //注册可重用cell
        //6.5.2 创建自定义LrcViewCell
        tableView.register(LrcViewCell.self, forCellReuseIdentifier: lrcCellID)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 35
        tableView.backgroundColor = .clear
        
        //print("证明tableView懒加载这时为nil,不合适设置frame属性\(tableView)")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //6.5.3 tabelView 位置设置
        let x : CGFloat = bounds.width
        let y : CGFloat = 0
        let w : CGFloat = bounds.width
        let h : CGFloat = bounds.height
        tableView.frame = CGRect(x: x, y: y, width: w, height: h)
//        tableView.backgroundColor = UIColor.clear
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK:- UITableView的数据源方法
extension LrcScrollView : UITableViewDataSource {
    
    
    //6.9 tableView数据源赋值
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lrclines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: lrcCellID, for: indexPath) as! LrcViewCell
        //7.3 对记录的下标cell，变色处理
        if indexPath.row == currentLineIndex {
            cell.lrcLabel.font = UIFont.systemFont(ofSize: 17.0)
            cell.lrcLabel.textColor = UIColor.white
        } else {
            cell.lrcLabel.textColor = UIColor.gray
            cell.lrcLabel.font = UIFont.systemFont(ofSize: 14.0)
            
        }
        
        let lrcline = lrclines![indexPath.row]
        cell.lrcLabel.text = lrcline.lrcText
        
        return cell
    }
}


extension LrcScrollView {
    func currentlineLrcAndNextLineLrc() {
       
        //  取出本句歌词
        let currentLrcText = lrclines![currentLineIndex].lrcText ?? ""
        //  取出上一句歌词
        var previousLrcText = ""
        if currentLineIndex - 1 >= 0 {
            previousLrcText = lrclines![currentLineIndex - 1].lrcText ?? ""
        }
        //  取出下一句歌词
        var nextLrcText = ""
        if currentLineIndex + 1 <= lrclines!.count - 1 {
            nextLrcText = lrclines![currentLineIndex + 1].lrcText ?? ""
        }
        
        // 7.8 通过代理回掉歌词
        lrcDelegate?.lrcScrollView(lrcScrollView: self, nextLrcText: nextLrcText, currentLrcText: currentLrcText, preLrcText: previousLrcText)
    }
}
