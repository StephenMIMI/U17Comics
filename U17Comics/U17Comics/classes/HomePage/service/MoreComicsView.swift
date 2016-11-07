//
//  MoreComicsView.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class MoreComicsView: NSObject {
    
    class func handleEvent(urlString: String, title: String?, onViewController vc: UIViewController) {
        let ctrl = MoreComicController()
        ctrl.viewType = ViewType.Subscribe
        ctrl.titleStr = title
        //手动让页面在url赋值之后初始化，其他值需要在url之前赋值
        ctrl.urlString = urlString
        vc.navigationController?.pushViewController(ctrl, animated: true)
    }
}
