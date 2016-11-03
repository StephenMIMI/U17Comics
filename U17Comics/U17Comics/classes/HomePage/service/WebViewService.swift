//
//  WebViewService.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class WebViewService: NSObject {
    
    class func handleWebEvent(urlString: String, onViewController vc: UIViewController) {
        let ctrl = WebViewController()
        ctrl.jumpUrl = urlString
        vc.navigationController?.pushViewController(ctrl, animated: true)
    }
}
