//
//  TableView.swift
//  UITest
//
//  Created by caffe on 2019/7/2.
//  Copyright © 2019 caffe. All rights reserved.
//

import UIKit
let CELL_ID = "msgCell"
let HEADER_ID = "headeCell"

enum ChatBubbleTypingType {
    case nobody
    case me
    case somebody
}

class TableView: UITableView {
    
    //用于保存所有消息
    var bubbleSection: Array<Array<MessageItem>>!
    //数据源, 用于与ViewController交换数据
    var chatDataSource: ChatDataSource!
    
    var snapInterval: TimeInterval!
    var typingBubble: ChatBubbleTypingType!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        
        // the snap interval in seconds implements a headerview to seperate chats
        self.snapInterval = TimeInterval.init( 60 * 60 * 24)
        self.typingBubble = .nobody
        
        super.init(frame: frame, style: style)
        
        self.bubbleSection = Array<Array<MessageItem>>()
        self.backgroundColor = .clear
        self.separatorStyle = .none
        self.delegate = self
        self.dataSource = self
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    override func reloadData() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        var count = 0
        if self.chatDataSource != nil {
            count = self.chatDataSource.rowsForChatTable(self)
            if count > 0 {
                var bubbleData = Array<MessageItem>()
                for index in 0 ..< count {
                    let object = self.chatDataSource.chatTableView(self, dataForRow: index)
                    bubbleData.append(object)
                }
                bubbleData.sort(by: sortData)
                
                var last = ""
                var currentSection = Array<MessageItem>()
                let dFormatter = DateFormatter.init()
                dFormatter.dateFormat = "dd"
                for index in 0 ..< count {
                    let data = bubbleData[index]
                    
                    // 使用日期格式化器, 根据日期不同, 重新分组
                    let dateStr = dFormatter.string(from: data.date)
                    
                    //如果日期与上一个不同, 创建新的section
                    if dateStr != last {
                        currentSection = Array<MessageItem>()
                        self.bubbleSection.append(currentSection)
                    }
                    self.bubbleSection[self.bubbleSection.count - 1].append(data)
                    
                    last = dateStr
                }
            }
        }
        super.reloadData()
        
        //始终显示最新消息
        let secNo = self.bubbleSection.count - 1
        let rowNo = self.bubbleSection[secNo].count
        let indexPath = IndexPath.init(row: rowNo, section: secNo)
        self.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    //按日期排序方法
    func sortData(_ m1: MessageItem, _ m2: MessageItem) -> Bool {
        if m1.date.timeIntervalSince1970 < m2.date.timeIntervalSince1970{
            return true
        }else{
            return false
        }
    }
}

extension TableView: UITableViewDelegate, UITableViewDataSource {
    
    //分区数
    func numberOfSections(in tableView: UITableView) -> Int {
        let result = self.bubbleSection.count
        
        if self.typingBubble != ChatBubbleTypingType.nobody {
            return result + 1
        }
        
        return result
    }
    
    //每个分区的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section >= self.bubbleSection.count){
            return 1
        }
        
        let result = self.bubbleSection[section].count + 1
        return result
    }
    
    //单元格的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //header
        if indexPath.row == 0 {
            return TableHeaderViewCell.getHeight()
        }
        let section = self.bubbleSection[indexPath.section]
        let data = section[indexPath.row - 1]
        
        let height = data.insets.top + max(data.view.frame.size.height, 52) + data.insets.bottom
        return height
    }
    
    //单元格
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // header based on snapInterval
        if indexPath.row == 0 {
            let headerCell = TableHeaderViewCell.init(reuseIdentifier: HEADER_ID)
            let section = self.bubbleSection[indexPath.section]
            let data = section[indexPath.row]
            
            headerCell.setDate(data.date)
            return headerCell
        }
        
        // standard message cell
        let section = self.bubbleSection[indexPath.section]
        let data = section[indexPath.row - 1]
        let msgCell = TableViewCell.init(data: data, reuseIdentifier: CELL_ID)
        return msgCell
    }
}
