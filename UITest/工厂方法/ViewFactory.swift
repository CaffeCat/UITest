//
//  ViewFactory.swift
//  UITest
//
//  Created by caffe on 2019/7/30.
//  Copyright © 2019 caffe. All rights reserved.
//

import Foundation
import UIKit

/*
 因为在实际的开发中往往需要设置一些主题颜色, 例如按钮需要统一进行字体小\颜色\font的属性设置, 如果需要在每次使用的时候才进行自定义, 可能会导致出现错漏, 并且需要每次检查.
 因此, 使用工厂类方法对一些必须要统一设置的UI控件属性进行设置, 非常有必要!
 工厂类方法实现的l思路非常简单, 但是这件事情的却可以省去很多不必要的检查. 只需要每次都简单遵守和使用这种方式即可.
 */

enum UIControlType {
    case UIControlLabel
    case UIControlButton
    case UIControlTextField
    case UIControlSegment
}

class ViewFactory {
    
    //对外工厂方法
    class func createControl(type: UIControlType, title: String?) -> Any {
        switch type {
        case .UIControlLabel:
            return ViewFactory.createLabel(title: title)
        case .UIControlButton:
            return self.createButton(title: title)
        default:
            return ViewFactory.createLabel(title: title)
        }
    }
    
    
    //MARK: - 私有创建方法
    private class func defaultFrame() -> CGRect {
        
        return CGRect.init(x: 0, y: 0, width: 100, height: 30)
    }
    
    private class func defaultColor() -> UIColor {
        
        //这里需要使用类方法, 因为可能颜色值存放在数据库
        return .orange
    }
    
    private class func defaultBgColor() -> UIColor {
        
        //这里的颜色值可能存在数据库中
        return .white
    }
    
    private class func createLabel(title: String?) -> UILabel {
        
        let label = UILabel.init(frame: self.defaultFrame())
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        label.textColor = self.defaultColor()
        label.backgroundColor = self.defaultBgColor()
        if title != nil {
            label.text = title
        }
        return label
    }
    
    private class func createButton(title: String?) -> UIButton {
        
        let button = UIButton.init(frame: self.defaultFrame())
        button.backgroundColor = self.defaultBgColor()
        button.setTitleColor(self.defaultColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        if title != nil {
            button.setTitle(title, for: .normal)
        }
        return button
    }
    
    private class func createTextField(title: String?) -> UITextField {
        
        let textField = UITextField.init(frame: self.defaultFrame())
        textField.textColor = self.defaultColor()
        textField.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        return textField
    }
    
    private class func createSegment(title: String?) -> UISegmentedControl {
        
        let segment = UISegmentedControl.init(frame: self.defaultFrame())
        segment.isMomentary = false
        return segment
    }
}
