//
//  UILabel+Common.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/21.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

extension UILabel {
    class func createLabel(title: String?, textAlignment: NSTextAlignment?, font: UIFont?)->UILabel {
        let label = UILabel()
        if let tmpTitle = title {
            label.text = tmpTitle
        }
        if let tmpAlignment = textAlignment {
            label.textAlignment = tmpAlignment
        }
        if let tmpFont = font {
            label.font = tmpFont
        }
        return label
    }
}