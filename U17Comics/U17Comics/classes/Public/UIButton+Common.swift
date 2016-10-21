//
//  UIButton+Common.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/21.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

extension UIButton {
    class func createBtn(title: String?, normalImage: String?, highlightImage:String?, selectImage:String?, target: AnyObject?, action:Selector?)->UIButton {
        let btn = UIButton()
        if let tmpTitle = title {
            btn.setTitle(tmpTitle, forState: .Normal)
        }
        if let tmpNormal = normalImage {
            btn.setBackgroundImage(UIImage(named: tmpNormal), forState: .Normal)
        }
        if let tmpHighlight = highlightImage {
            btn.setBackgroundImage(UIImage(named: tmpHighlight), forState: .Highlighted)
        }
        if let tmpSelect = selectImage {
            btn.setBackgroundImage(UIImage(named: tmpSelect), forState: .Selected)
        }
        if target != nil && action != nil {
            btn.addTarget(target, action: action!, forControlEvents: .TouchUpInside)
        }
        return btn
    }
}
