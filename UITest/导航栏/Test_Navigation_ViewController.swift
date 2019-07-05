//
//  Test_Navigation_ViewController.swift
//  UITest
//
//  Created by caffe on 2019/7/5.
//  Copyright © 2019 caffe. All rights reserved.
//

import UIKit

class Test_Navigation_ViewController: UIViewController {
    //表格加载
    var tableView: UITableView!
    //控件类型
    var ctls = ["UILabel", "UIButton", "UIImageView", "UISlider", "UIWebView"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillLayoutSubviews() {
        setupUserInterface()
    }
    
    func setupUserInterface() {
        self.title = "Swift控件演示"
        self.tableView = UITableView.init(frame: self.view.frame, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
        self.view.addSubview(self.tableView)
    }
}

extension Test_Navigation_ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ctls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.ctls[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中状态
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = Navigation_Detail_ViewController.init()
        detailVC.title = self.ctls[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
