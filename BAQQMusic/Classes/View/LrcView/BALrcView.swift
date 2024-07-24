//
//  BALrcView.swift
//  BAQQMusic
//
//  Created by boai on 2024/7/23.
//

import UIKit
import Foundation

class BALrcView: UIView {
    
    var currentLine: Int = 0
    var lrcLines: [BALrcLineModel]?
    
    var updateCurrentLrcs: ((_ currentLrcs: [BALrcLineModel]) -> Void)?
    
    var lrcFileName: String? {
        didSet {
            tableView.setContentOffset(CGPoint(x: 0, y: -bounds.height * 0.5), animated: false)

            guard let name = lrcFileName else { return }
            lrcLines = BALrcTool.parseLrc(lrcFileName: name)
            tableView.reloadData()
        }
    }
    
    var currentTime: TimeInterval = 0 {
        didSet {
            guard let datas = lrcLines else { return }
            
            let count = datas.count
            
            //获取当前播放到那句歌词
            for i in 0..<count {
                //当前句歌词
                let currentLineLrc = datas[i]
                
                //下一句歌词
                let nextLine = i + 1
                if nextLine > count - 1 {
                    continue
                }
                let nextLineLrc = datas[nextLine]
                
                //取得当前两句歌词之间的时间
                if currentTime >= currentLineLrc.lrcTime &&
                    currentTime < nextLineLrc.lrcTime {
                    if i == currentLine {
                        return
                    }
                    currentLine = i
                    
                    var temp: [BALrcLineModel] = []
                    let preLine = i - 1
                    if preLine >= 0 {
                        let preLineLrc = datas[preLine]
                        temp.append(preLineLrc)
                    }
                    temp.append(currentLineLrc)
                    temp.append(nextLineLrc)
                    updateCurrentLrcs!(temp)
                    
                    let currentIndexPath = IndexPath(row: i, section: 0)
                    let preIndexPath = IndexPath(row: i, section: 0)
                    //刷新正在播放的歌词与前一句
//                    tableView.reloadRows(at: [currentIndexPath, preIndexPath], with: .none)
                    tableView.reloadData()
                    tableView.scrollToRow(at: currentIndexPath, at: .middle, animated: true)
                }
            }
        }
    }
    
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
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func initData() -> Void {
        //更新歌词进度
        BAAudioPlayer.shared.onUpdageLrc = { [weak self] time in
            guard let self = self else { return }
            
            currentTime = BAAudioPlayer.shared.getCurrentTime()
        }
    }
    
    //MARK: lazy
    
    lazy var tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .cyan.withAlphaComponent(0.1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 40
        
        tableView.register(BALrcCell.self, forCellReuseIdentifier: BALrcCell.description())
        
        return tableView
    }()
    
}

extension BALrcView {
   
}

extension BALrcView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lrcLines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BALrcCell = tableView.dequeueReusableCell(withIdentifier: BALrcCell.description(), for: indexPath) as! BALrcCell
      
        cell.updateLine(lrcModel: lrcLines![indexPath.row], isCurrent: indexPath.row == currentLine)
        
        return cell
    }
    
    
}
