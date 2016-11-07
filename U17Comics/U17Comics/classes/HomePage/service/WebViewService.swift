//
//  WebViewService.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class WebViewService: NSObject {
    
    class func handleEvent(urlString: String, title:String?, onViewController vc: UIViewController) {
        let ctrl = WebViewController()
        ctrl.webTitle = title
        ctrl.jumpUrl = urlString
        vc.navigationController?.pushViewController(ctrl, animated: true)
    }
}
