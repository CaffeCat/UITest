//
//  Test_basic_tableview_ViewController.swift
//  UITest
//
//  Created by caffe on 2019/7/4.
//  Copyright © 2019 caffe. All rights reserved.
//

import UIKit

class Test_basic_tableview_ViewController: UIViewController {

    var tableView: UITableView?
    var allNames: Dictionary<Int, [String]>?
    var adHeaders: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        createData()
    }
    func createData() {
        
        //初始化数据，这一次数据，我们放在属性列表文件里
        self.allNames = [
            0:[String]([
                "UILabel 标签",
                "UIButton 按钮"]),
            1:[String]([
                "UIDatePiker 日期选择器",
                "UITableView 表格视图"])
        ]
        
        self.adHeaders = [
            "常见 UIKit 控件",
            "高级 UIKit 控件"
        ]
        
        //创建表视图
        self.tableView = UITableView.init(frame: self.view.frame, style: .grouped)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "SwiftCell")
        self.view.addSubview(self.tableView!)
        
        //创建表头标签
        let headerLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0,
                                                          width: self.view.bounds.size.width, height: 30))
        headerLabel.backgroundColor = .black
        headerLabel.textColor = .white
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.text = "UIKit 控件"
        headerLabel.font = .italicSystemFont(ofSize: 20)
        self.tableView?.tableHeaderView = headerLabel
        
        //绑定长按手势
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(tableViewCellLongPressed(_:)))
        longPress.delegate = self
        longPress.minimumPressDuration = 1.0
        self.tableView?.addGestureRecognizer(longPress)
    }
}

//手势功能的类扩展
extension Test_basic_tableview_ViewController: UIGestureRecognizerDelegate {
    
    @objc func tableViewCellLongPressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            print("UIGestureRecognizerStateBegan")
        }else if gestureRecognizer.state == .changed {
            
            print("UIGestureRecognizerStateChanged")
        }else if gestureRecognizer.state == .ended{
            
            print("UIGestureRecognizerStateEnded")
            //在正常状态和编辑状态之间切换
            if self.tableView?.isEditing == false {
                self.tableView?.setEditing(true, animated: true)
            }else {
                self.tableView?.setEditing(true, animated: true)
            }
            self.tableView?.reloadData()
        }
        
    }
}

//表的类扩展
extension Test_basic_tableview_ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.allNames!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = self.allNames?[section]
        var count = data!.count
        if self.tableView!.isEditing {
            count += 1
        }
        return data!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headers = self.adHeaders!
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let data = self.allNames?[section]
        return "有\(data!.count)个控件"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //为了提高表格显示性能,已创建的单元格要重用. 已经注册的单元格可以重用
        let identifier = "SwiftCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let secNo = indexPath.section
        var data = self.allNames?[secNo]
        
        if tableView.isEditing && indexPath.row == data!.count {
            cell.textLabel?.text = "添加新数据"
        } else {
            cell.textLabel?.text = data![indexPath.row]
        }
        
        return cell
    }
    
    //单元格选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let itemStr = self.allNames![indexPath.section]![indexPath.row]
        
        let alertController = UIAlertController.init(title: "提示",
                                                     message: "你选中了\(itemStr)",
                                                     preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //设置单元格的编辑样式
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let secNo = indexPath.section
        let data = self.allNames?[secNo]
        
        if tableView.isEditing == false {
            return .none
        }else if indexPath.row == data?.count {
            return .insert
        }else{
            return .delete
        }
        
    }
    
    //设置确认删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        var data = self.allNames?[indexPath.section]!
        let itemStr = data![indexPath.row]
        return "确定删除\(itemStr)?"
    }
    
    //单元格编辑后 (插入或删除) 的响应方法
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.allNames?[indexPath.section]?.remove(at: indexPath.row)
            
            tableView.reloadData()
            print("你确认了删除按钮")
        }else if editingStyle == .insert {
            self.allNames?[indexPath.section]?.insert("这是插入的新数据", at: indexPath.row + 1)
            tableView.reloadData()
            print("你按下了插入按钮")
        }
    }
}
