//
//  TestTableView_ViewController.swift
//  UITest
//
//  Created by caffe on 2019/7/2.
//  Copyright © 2019 caffe. All rights reserved.
//

import UIKit

class TestTableView_ViewController: UIViewController {

    var chats: Array<MessageItem>!
    var tableView: TableView!
    var me: UserInfo!
    var you: UserInfo!
    var txtMsg: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        setupChatTable()
        setupSendPanel()
    }
    
    func setupSendPanel() {
        let screenWidth = UIScreen.main.bounds.width
        let sendView = UIView.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 56, width: screenWidth, height: 56))
        sendView.backgroundColor = .lightGray
        sendView.alpha = 0.9
        
        txtMsg = UITextField.init(frame: CGRect.init(x: 7, y: 10, width: screenWidth - 95, height: 36))
        txtMsg.backgroundColor = .white
        txtMsg.textColor = .black
        txtMsg.font = .boldSystemFont(ofSize: 12)
        txtMsg.layer.cornerRadius = 10
        txtMsg.returnKeyType = .send
        txtMsg.delegate = self
        sendView.addSubview(txtMsg)
        self.view.addSubview(sendView)
        
        let sendButton = UIButton.init(frame: CGRect.init(x: screenWidth - 80, y: 10, width: 72, height: 36))
        sendButton.backgroundColor = UIColor.init(red: 0x37/255, green: 0xba/255, blue: 0x46/255, alpha: 1)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        sendButton.layer.cornerRadius = 6.0
        sendButton.setTitle("发送", for: .normal)
        sendView.addSubview(sendButton)
    }
    
    func setupChatTable() {

        let frame = CGRect.init(x: 0, y: 20,
                                width: self.view.frame.size.width,
                                height: self.view.frame.height - 76)
        self.tableView = TableView.init(frame: frame, style: .plain)
        
        //创建一个重用的单元格
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: CELL_ID)
        self.tableView.register(TableHeaderViewCell.self, forCellReuseIdentifier: HEADER_ID)
        
        me = UserInfo.init(name: "xiaoming", logo: "xiaoming.png")
        you = UserInfo.init(name: "xiaohua", logo: "xiaohua.png")
        
        let zero = MessageItem.init(body: "最近去哪里玩了?", user: you,
                                    date: Date.init(timeIntervalSince1970: -90096400), mtype: .someone)
        let zero1 = MessageItem.init(body: "去了趟苏州", user: me,
                                     date: Date.init(timeIntervalSince1970: -90086400), mtype: .mine)
        let first = MessageItem.init(body: "我到苏州啦, 看看水乡", user: me,
                                     date: Date.init(timeIntervalSinceNow: -90000600),
                                     mtype: .mine)
        let second = MessageItem.init(image: UIImage.init(named: "sz.png")!, user: me,
                                      date: Date.init(timeIntervalSinceNow: -90000290),
                                      mtype: .mine)
        let third = MessageItem.init(body: "我靠, 这就去了", user: you,
                                     date: Date.init(timeIntervalSinceNow: -300),
                                     mtype: .someone)
        let fourth = MessageItem.init(body: "挺别致的", user: you,
                                      date: Date.init(timeIntervalSinceNow: -200),
                                      mtype: .someone)
        let fifth = MessageItem.init(body: "早叫你不来", user: me,
                                     date: Date.init(timeIntervalSinceNow: 0),
                                     mtype: .mine)
        let sixth = MessageItem.init(image: UIImage.init(named: "sz.png")!, user: you,
                                     date: Date.init(timeIntervalSinceNow: -100),
                                     mtype: .someone)
        chats = [first, second, third, fourth, fifth, sixth, zero, zero1]
        //chats = [zero, second]
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        self.view.addSubview(self.tableView)
    }
}

extension TestTableView_ViewController: ChatDataSource {
    func rowsForChatTable(_ tableView: TableView) -> Int {
        return self.chats.count
    }
    
    func chatTableView(_ tableView: TableView, dataForRow row: Int) -> MessageItem {
        return chats[row]
    }
}

extension TestTableView_ViewController: UITextFieldDelegate{
    
    @objc func sendMessage() {
        let text = txtMsg.text ?? " "
        let thisChat = MessageItem.init(body: text, user: me, date: Date.init(), mtype: .mine)
        let thatChat = MessageItem.init(body: "你说的是\(text)", user: you, date: Date.init(), mtype: .someone)
        chats.append(thisChat)
        chats.append(thatChat)
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        txtMsg.resignFirstResponder()
        txtMsg.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}
