//
//  Navigation_Detail_ViewController.swift
//  UITest
//
//  Created by caffe on 2019/7/5.
//  Copyright © 2019 caffe. All rights reserved.
//

import UIKit
import WebKit

class Navigation_Detail_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        let btn = UIBarButtonItem.init(title: "代码", style: .plain,
                                       target: self, action: #selector(btnCodeClicked(_:)))
        self.navigationItem.rightBarButtonItem = btn
    }
    
    override func viewDidLayoutSubviews() {
        loadControl(ctrl: self.title!)
    }
    
    @objc func btnCodeClicked(_ button: UIButton) {
        print("title:\(self.title!)")
        self.clearViews()
        if self.navigationItem.rightBarButtonItem?.title == "代码" {
            loadCode(ctrl: self.title!)
            self.navigationItem.rightBarButtonItem?.title = "效果"
        } else {
            loadControl(ctrl: self.title!)
            self.navigationItem.rightBarButtonItem?.title = "代码"
        }
    }
    
    func clearViews() {
        for item in self.view.subviews {
            item.removeFromSuperview()
        }
    }
    
    func loadCode(ctrl: String) {
        var str: String
        switch ctrl {
        case "UILabel":
            str = "let label = UILabel(frame: self.view.bounds)\n"
            str += "label.backgroundColor = UIColor.clearColor()\n"
            str += "label.textAlignment = NSTextAlignment.Center\n"
            str += "label.font = UIFont.systemFontOfSize(36)\n"
            str += "label.text = \"Hello, Ucai\"\n"
            str += "self.view.addSubview(label)"
        case "UIButton":
            str = "UIButton"
        case "UISlider":
            str = "let slider = UISlider(frame:CGRectMake(60.0, 120.0, 200.0, 30.0))\n"
            str += "self.view.addSubview(slider)"
        default:
            str = "other ctrl"
        }
        
        let txt = UITextView.init(frame: CGRect.init(x: 0, y: 60,
                                                     width: self.view.bounds.width,
                                                     height: self.view.bounds.height - 60))
        txt.text = str
        self.view.addSubview(txt)
    }
    
    func loadControl(ctrl: String) {
        switch ctrl {
        case "UILabel":
            let label = UILabel.init(frame: self.view.bounds)
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 36)
            label.text = "Hello, world!"
            self.view.addSubview(label)
        case "UIButton":
            let button = UIButton.init(frame: CGRect.init(x: 110, y: 120, width: 100, height: 60))
            button.backgroundColor = .blue
            button.setTitleColor(.red, for: .normal)
            button.setTitleColor(.white, for: .highlighted)
            button.setTitle("点击我", for: .normal)
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            self.view.addSubview(button)
        case "UIImageView":
            let image = UIImage.init(named: "sz.png")
            let frame = CGRect.init(x: 50, y: 120.0,
                                    width: 200,
                                    height: 200)
            let imageView = UIImageView.init(frame: frame)
            imageView.image = image!
            self.view.addSubview(imageView)
        case "UISlider":
            let slider = UISlider.init(frame: CGRect.init(x: 60, y: 120, width: 200, height: 30))
            self.view.addSubview(slider)
        case "UIWebView":
            let webView = WKWebView.init(frame: self.view.bounds)
            let url = URL.init(string: "www.baidu.com")
            let request = URLRequest.init(url: url!)
            webView.load(request)
            self.view.addSubview(webView)
        default:
            print("control name:\(ctrl)")
        }
    }
    
    @objc func buttonClicked(_ button: UIButton) {
        print("you clicked button")
    }
}
