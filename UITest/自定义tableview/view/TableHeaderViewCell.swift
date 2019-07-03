//
//  TableHeaderViewCell.swift
//  UITest
//
//  Created by caffe on 2019/7/2.
//  Copyright © 2019 caffe. All rights reserved.
//

import UIKit

class TableHeaderViewCell: UITableViewCell {

    var height: CGFloat = 30
    var label: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    init(reuseIdentifier cellId: String) {
        super.init(style: .default, reuseIdentifier: cellId)
    }
    
    func setDate(_ value: Date) {
        self.height = 30
        
        let dataFormatter = DateFormatter.init()
        dataFormatter.dateFormat = "yyyy年MM月dd日"
        let text = dataFormatter.string(from: value)
        
        if self.label != nil {
            self.label.text = text
            return
        }
        
        self.selectionStyle = .none
        self.label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: height))
        self.label.text = text
        self.label.font = UIFont.boldSystemFont(ofSize: 12)
        self.label.textAlignment = .center
        self.label.shadowOffset = CGSize.init(width: 0, height: 1)
        self.label.shadowColor = .white
        self.label.textColor = .darkGray
        self.label.backgroundColor = .clear
        self.addSubview(self.label)
    }
    
    class func getHeight() -> CGFloat {
        
        return 30
    }
    
    //默认自带的函数
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
