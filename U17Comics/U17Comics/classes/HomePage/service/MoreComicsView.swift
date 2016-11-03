//
//  MoreComicsView.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class MoreComicsView: NSObject {
    
    class func handleMoreComics(urlString: String, onViewController vc: UIViewController) {
        let ctrl = MoreComicController()
        ctrl.viewType = ViewType.Subscribe
        ctrl.urlString = urlString
        vc.navigationController?.pushViewController(ctrl, animated: true)
    }
}
