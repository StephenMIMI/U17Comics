//
//  CustomNavigationProtocol.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/7.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

enum BarButtonPosition {
    case left
    case right
}

protocol CustomNavigationProtocol: NSObjectProtocol {
    func addTitle(title: String)
    func addBarButton(btn: UIButton?, position: BarButtonPosition)
}

extension CustomNavigationProtocol where Self: UIViewController {
    func addTitle(title: String) {
        let label = UILabel(frame: CGRectMake(0,0,100,44))
        label.text = title
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = .Center
        navigationItem.titleView = label
    }
    
    func addBarButton(btn: UIButton?, position: BarButtonPosition) {
        if btn != nil {
            let barButtonItem = UIBarButtonItem(customView: btn!)
            if position == BarButtonPosition.left {
                navigationItem.leftBarButtonItem = barButtonItem
            }else if position == BarButtonPosition.right {
                navigationItem.rightBarButtonItem = barButtonItem
            }
        }
    }
}