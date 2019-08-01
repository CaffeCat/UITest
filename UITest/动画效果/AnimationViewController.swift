//
//  AnimationViewController.swift
//  UITest
//
//  Created by caffe on 2019/7/31.
//  Copyright © 2019 caffe. All rights reserved.
//

import UIKit

/*
 动画效果的实现方法: 在 iOS 中，实现动画有两种方法。一个是统一的 animate，另一个是组合出现的 beginAnimations 和 commitAnimations。这三个方法都是类方法。
 
 -- 使用 animate 来实现动画
 （1）此方法共有5个参数：
     withDuration：动画从开始到结束的持续时间，单位是秒
     delay：动画开始前等待的时间
     options：动画执行的选项。里面可以设置动画的效果。可以使用 UIViewAnimationOptions 类提供的各种预置效果
     anmations：动画效果的代码块
     completion：动画执行完毕后执行的代码块
 （2）UIView支持动画效果的属性
     frame：此属性包含一个矩形，即边框矩形，此值确定了当前视图在其父视图坐标系中的位置与尺寸
     bounds：也是矩形，边界矩形，它指的是视图在其自己的坐标系中的位置和尺寸，左上角坐标永远是 (0,0)
     center：确定视图的中心点在其父视图坐标系中的位置坐标。即定义当前视图在父视图中的位置
     alpha：视图的透明度。（但视图完全透明时，不能响应触摸消息）
     backgroundColor：背景色
     transform：这是一种 3×3 的变化矩阵。通过这个矩阵我们可以对一个坐标系统进行缩放、平移、旋转以及这两者的任意组操作。
 （3）Transform（变化矩阵）的四个常用的变换方法
     CGAffineTransformMake()：返回变换矩阵
     CGAffineTransformMakeTranslation()：返回平移变换矩阵
     CGAffineTransformMakeScale()：返回缩放变换矩阵
     CGAffineTransformMakeRotation()：返回旋转变换矩阵
 
 -- 使用 beginAnimations 和 commitAnimations 方法来实现动画
    beginAnimations：此方法开始一个动画块，调用 commitAnimations 结束一个动画块，并且动画块是允许嵌套的。
    commitAnimations：此方法用于结束一个动画块，动画是在一个独立的线程中运行的，动画在生效时，所有应用程序不会中断。
    在 beginAnimations 和 commitAnimations 中间的代码中，我们可以设置各种动画的属性。比如持续时间，使用哪种预置的动画效果等。
 
 -- 两个视图切换的过渡动画 UIViewAnimationTransition , 5种定义的类型:
    none：无过渡动画效果
    flipFromLeft：从左侧向右侧翻转
    flipFromRight：从右侧向左侧翻转
    curlUp：向上卷数翻页
    curlDown：向下翻页
*/

class AnimationViewController: UIViewController {

    //游戏方格维度
    var dimension = 4
    //数字格子的宽度
    var width: CGFloat = 50
    //格子与格子的间距
    var padding: CGFloat = 6
    
    //保存背景图数据
    var backgrounds: Array<UIView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgrounds = Array<UIView>()
        setupGameMap()
        playAnimation()
    }
    
    func setupGameMap() {
        
        var x: CGFloat = 50
        var y: CGFloat = 150
        
        for index in 0 ..< dimension {
            print(index)
            y = 150
            for _ in 0 ..< dimension {
                let background = UIView.init(frame: CGRect.init(x: x, y: y, width: width, height: width))
                background.backgroundColor = UIColor.darkGray
                self.view.addSubview(background)
                backgrounds.append(background)
                y += padding + width
            }
            x += padding + width
        }
    }
    
    // MARK: - 使用 animate
    
    //  原图 --> 1/10大小 --> 旋转90° --> 恢复原样
    func playAnimation() {
        
        for tile in backgrounds {
            
            //先将数字块大小设置为原始尺寸的 1/10
            tile.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.1, y: 0.1))
            
            //设置动画效果
            UIView.animate(withDuration: 1, delay: 0.01, options: [], animations: {
                //旋转90度
                tile.layer.setAffineTransform(CGAffineTransform.init(rotationAngle: 90))
            }) { (finish: Bool) in
                UIView.animate(withDuration: 1, animations: {
                    //完成动画时, 数字块复原
                    tile.layer.setAffineTransform(CGAffineTransform.identity)
                })
            }
        }
    }
    
    // 原图 --> 1/10大小 --> 原图
    func playAnimationScale() {
        
        for tile in backgrounds {
            
            //先将数字块大小设置为原始尺寸的 1/10
            tile.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.1, y: 0.1))
            
            //设置动画效果
            UIView.animate(withDuration: 1, delay: 0.01, options: [], animations: {
                tile.layer.setAffineTransform(CGAffineTransform.init(scaleX: 1, y: 1))
            }) { (finished) in
                UIView.animate(withDuration: 0.08, animations: {
                    tile.layer.setAffineTransform(CGAffineTransform.identity)
                })
            }
        }
    }
    
    // 原图 --> 透明 --> 不透明
    func playAnimationAlpha() {
        
        for tile in backgrounds {
            
            tile.alpha = 0
            UIView.animate(withDuration: 1, delay: 0.01, options: [.curveEaseInOut], animations: {
                
            }) { (finished) in
                UIView.animate(withDuration: 1, animations: {
                    tile.alpha = 1
                })
            }
        }
    }
    
    // MARK: - 使用 beginAnimations 和 commitAnimations
    func animationsWithBeginCommit() {
        
        let imageView = UIImageView.init()
        
        //淡出动画
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        imageView.alpha = 0
            /* 这里写需要展示的动画 */
        UIView.commitAnimations()
        
        //淡入动画
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        imageView.alpha = 1
            /* 这里写需要展示的动画 */
        UIView.commitAnimations()
        
        //移动动画
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        imageView.center = CGPoint.init(x: 250, y: 250)
            /* 这里写需要展示的动画 */
        UIView.commitAnimations()
        
        //大小调整动画
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        imageView.frame = CGRect.init(x: 100, y: 180, width: 50, height: 50)
            /* 这里写需要展示的动画 */
        UIView.commitAnimations()
    }
    
    // MARK: - 视图切换过渡动画 UIViewAnimationTransition
    func playTransitionAnimation() {
        
        //创建一个按钮, 用来点击播放动画
        let button = UIButton.init(type: .system)
        button.frame = CGRect.init(x: 10, y: 20, width: 100, height: 30)
        button.setTitle("播放动画", for: .normal)
        button.addTarget(self, action: #selector(self.playTransitionClicked), for: .touchUpInside)
        self.view.addSubview(button)
        
        //动画切换的视图: 红蓝视图
        let redView = UIView.init(frame: CGRect.init(x: 50, y: 50, width: 150, height: 400))
        redView.backgroundColor = .red
        self.view.insertSubview(redView, at: 0)
        let blueView = UIView.init(frame: CGRect.init(x: 50, y: 50, width: 150, height: 400))
        blueView.backgroundColor = .blue
        self.view.insertSubview(blueView, at: 1)
    }
    
    @objc func playTransitionClicked() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        UIView.setAnimationTransition(.curlUp, for: self.view, cache: true)
        self.view.exchangeSubview(at: 1, withSubviewAt: 0)
        UIView.commitAnimations()
    }
    
    //页面翻转或元件翻转效果
    func palyTransitionAnimationInOut() {
        
        //创建一个按钮，用来点击播放动画
        let button = UIButton.init(type: .system)
        button.frame = CGRect.init(x: 10, y: 20, width: 100, height: 30)
        button.setTitle("播放动画", for: .normal)
        button.addTarget(self, action: #selector(playTransitionInOut), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func playTransitionInOut() {
        
        //将整个主视图面板实现一个翻转效果
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        UIView.setAnimationCurve(.easeInOut)
        UIView.setAnimationTransition(.flipFromLeft, for: self.view, cache: false)
        UIView.commitAnimations()
    }
}
