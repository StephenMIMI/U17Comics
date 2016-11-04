//
//  ComicDetailView.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class ComicDetailView: NSObject {
    
    class func handleEvent(urlString: String, onViewController vc: UIViewController) {
        let ctrl = ComicDetailController()
        ctrl.jumpUrl = urlString
        vc.navigationController?.pushViewController(ctrl, animated: true)
    }
}
