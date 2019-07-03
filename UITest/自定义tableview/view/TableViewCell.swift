//
//  TableViewCell.swift
//  UITest
//
//  Created by caffe on 2019/7/2.
//  Copyright © 2019 caffe. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    //消息内容视图
    var customView: UIView!
    //消息背景
    var bubbleImage: UIImageView!
    //头像
    var avatarImage: UIImageView!
    //消息数据结构
    var msgItem: MessageItem!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    init(data: MessageItem, reuseIdentifier cellId: String) {
        self.msgItem = data
        super.init(style: .default, reuseIdentifier: cellId)
        rebuildUserInterface()
        //self.backgroundColor = .red
    }
    
    func rebuildUserInterface() {
        
        self.selectionStyle = .none
        if self.bubbleImage == nil {
            self.bubbleImage = UIImageView.init()
            self.addSubview(self.bubbleImage)
        }
        
        let type = self.msgItem.mtype
        let width = self.msgItem.view.frame.size.width
        let height = self.msgItem.view.frame.size.height
        
        var x = (type == ChatType.someone) ? 0 : self.frame.size.width - width - self.msgItem.insets.left - self.msgItem.insets.right
        
        var y: CGFloat = 0
        
        //显示用户头像
        if self.msgItem.user.name != "" {
            
            let thisUser = self.msgItem.user
            
            let imageName = (thisUser.avatar != "") ? thisUser.avatar : "noAvatar.png"
            
            self.avatarImage = UIImageView.init(image: UIImage.init(named: imageName))
            self.avatarImage.layer.cornerRadius = 9.0
            self.avatarImage.layer.masksToBounds = true
            self.avatarImage.layer.borderColor = UIColor.init(white: 0.0, alpha: 0.2).cgColor
            self.avatarImage.layer.borderWidth = 1.0
            
            //别人的头像在左边, 我的头像在右边
            let avatarX = (type == ChatType.someone) ? 2 : self.frame.size.width - 52
            
            //头像居于消息顶部
            let avatarY: CGFloat =  0
            
            //set the frame correctly
            self.avatarImage.frame = CGRect.init(x: avatarX, y: avatarY, width: 50, height: 50)
            self.addSubview(self.avatarImage)
            
            //如果消息内容height < 头像 height, 消息在头像居中
            let delta = (50 - (self.msgItem.insets.top + self.msgItem.insets.bottom + self.msgItem.view.frame.size.height))/2
            if delta > 0 {
                y = delta
            }

            if type == ChatType.someone {
                x += 54
            }else if type == ChatType.mine {
                x -= 54
            }
        }
        
        self.customView = self.msgItem.view
        self.customView.frame = CGRect.init(x: x + self.msgItem.insets.left, y: y + self.msgItem.insets.top,
                                            width: width, height: height)
        self.addSubview(self.customView)
        
        //别人的消息左边, 我的消息右边
        if type == ChatType.someone {
            self.bubbleImage.image = UIImage.init(named: "yourBubble.png")?.stretchableImage(withLeftCapWidth: 21, topCapHeight: 25)
        }else{
            self.bubbleImage.image = UIImage.init(named: "mineBubble.png")?.stretchableImage(withLeftCapWidth: 21, topCapHeight: 25)
        }
        self.bubbleImage.frame = CGRect.init(x: x, y: y,
                                             width: width + self.msgItem.insets.left + self.msgItem.insets.right,
                                             height: height + self.msgItem.insets.top + self.msgItem.insets.bottom)
    }
    
    //单元格宽度始终为屏幕宽度
    override var frame: CGRect{
        get{
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.size.width = UIScreen.main.bounds.width
            super.frame = frame
        }
    }
    
    //默认自带的函数
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
