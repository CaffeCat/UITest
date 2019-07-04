//
//  ChatDataSource.swift
//  UITest
//
//  Created by caffe on 2019/7/2.
//  Copyright © 2019 caffe. All rights reserved.
//

import Foundation

protocol ChatDataSource {
    //返回对话记录中的全部行数
    func rowsForChatTable(_ tableView: TableView) -> Int
    //返回某一行的内容
    func chatTableView(_ tableView: TableView, dataForRow row: Int) -> MessageItem
}
