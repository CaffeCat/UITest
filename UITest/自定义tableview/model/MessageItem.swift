//
//  MessageItem.swift
//  UITest
//
//  Created by caffe on 2019/6/28.
//  Copyright © 2019 caffe. All rights reserved.
//

import Foundation
import UIKit

//消息类型, 消息的收发方
enum ChatType {
    case mine
    case someone
}

class MessageItem {
    //头像
    var user: UserInfo
    //消息时间
    var date: Date
    //消息类型
    var mtype: ChatType
    //内容视图, 标签或者图片
    var view: UIView
    //边距
    var insets: UIEdgeInsets
    
    //初始化消息
    init(user: UserInfo, date: Date, mtype: ChatType, view: UIView, insets: UIEdgeInsets) {
        self.user = user
        self.date = date
        self.mtype = mtype
        self.view = view
        self.insets = insets
    }
    
    //构造图片消息体
    convenience init(image: UIImage, user: UserInfo, date: Date, mtype: ChatType) {
        
        var size = image.size
        
        //等比例缩放
        if(size.width > 220){
            size.height /= (size.width/220.0)
            size.width = 220.0
        }
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        imageView.image = image
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        
        let insets = (mtype == ChatType.mine ? MessageItem.getImageInsetsMine() : MessageItem.getImageInsetsSomeone())
        
        self.init(user: user, date: date, mtype: mtype, view: imageView, insets: insets)
    }
    
    //构造文本消息体
    convenience init(body: String, user: UserInfo, date: Date, mtype: ChatType) {
        let font = UIFont.boldSystemFont(ofSize: 12)
        let width = 225, height = 10000.0
        let atts = [NSAttributedString.Key.font: font]
        
        //计算给定属性文本显示需要的宽高等信息
        let size = body.boundingRect(with: CGSize(width: CGFloat(width), height: CGFloat(height)),
                                     options: .usesLineFragmentOrigin, attributes:atts, context:nil)
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: size.size.width, height: size.size.height))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = (body.count > 0 ? body : "")
        label.font = font
        label.backgroundColor = .clear
        
        let insets = (mtype == ChatType.mine ? MessageItem.getTextInsetsMine() : MessageItem.getTextInsetsSomeone())
        self.init(user: user, date: date, mtype: mtype, view: label, insets: insets)
    }
    
    //设置我的文本消息边距
    class func getTextInsetsMine() -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 10, bottom: 11, right: 17)
    }
    //设置他人的文本消息边框
    class func getTextInsetsSomeone() -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 15, bottom: 11, right: 10)
    }
    
    //设置我的图片消息边框
    class func getImageInsetsMine() -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 15)
    }
    //设置他人的图片消息边框
    class func getImageInsetsSomeone() -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 15, bottom: 10, right: 10)
    }
}
