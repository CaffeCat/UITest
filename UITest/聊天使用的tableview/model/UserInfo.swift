//
//  UserInfo.swift
//  UITest
//
//  Created by caffe on 2019/7/2.
//  Copyright © 2019 caffe. All rights reserved.
//

import Foundation

/*
 用户信息类
 */

class UserInfo {
    var name: String = ""
    var avatar: String = ""
    
    init(name: String, logo: String) {
        self.name = name
        self.avatar = logo
    }
}
