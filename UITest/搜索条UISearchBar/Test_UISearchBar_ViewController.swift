//
//  Test_UISearchBar_ViewController.swift
//  UITest
//
//  Created by caffe on 2019/7/5.
//  Copyright © 2019 caffe. All rights reserved.
//

import UIKit

class Test_UISearchBar_ViewController: UIViewController {

   //展示列表
    var tableView: UITableView!
    //搜索控制器
    var searchController = UISearchController.init()
    
    //原始数据集
    let schoolArray = ["0清华大学","0北京大学","0中国人民大学","1北京交通大学","1北京工业大学",
                       "2北京航空航天大学","2北京理工大学","3北京科技大学","3中国政法大学",
                       "4中央财经大学","4华北电力大学","5北京体育大学","5上海外国语大学","6复旦大学",
                       "6华东师范大学","7上海大学","7河北工业大学"]
    //搜索过滤后的数据集
    var searchArray: [String] = [String]() {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        setupUserInterface()
        self.tableView.reloadData()
    }
    
    func setupUserInterface() {
        let tableViewFrame = CGRect.init(x: 0, y: 20,
                                         width: self.view.frame.width,
                                         height: self.view.frame.height - 20)
        self.tableView = UITableView.init(frame: tableViewFrame, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //注册可重用的单元格
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
        self.view.addSubview(self.tableView)
        
        //配置搜索控制器
        self.searchController = ({
            let controller = UISearchController.init(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.delegate = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .minimal
            controller.searchBar.sizeToFit()
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
    }
}

extension Test_UISearchBar_ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.searchArray.count
        } else {
            return self.schoolArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        if self.searchController.isActive {
            cell.textLabel?.text = self.searchArray[indexPath.row]
        } else {
            cell.textLabel?.text = self.schoolArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension Test_UISearchBar_ViewController: UISearchResultsUpdating {
    
    //实时进行搜索
    func updateSearchResults(for searchController: UISearchController) {
        self.searchArray = self.schoolArray.filter({ (school) -> Bool in
            return school.contains(searchController.searchBar.text!)
        })
    }
}

extension Test_UISearchBar_ViewController: UISearchBarDelegate {
    
    //点击搜索按钮
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchArray = self.schoolArray.filter({ (school) -> Bool in
            return school.contains(searchBar.text!)
        })
    }
    
    //点击取消按钮
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchArray = self.schoolArray
    }
}
