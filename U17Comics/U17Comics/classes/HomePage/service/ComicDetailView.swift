//
//  ComicDetailView.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class ComicDetailView: NSObject {
    
    class func handleEvent(urlString: String, comicTicket: String?, onViewController vc: UIViewController) {
        let ctrl = ComicDetailController()
        ctrl.ticketUrl = comicTicket//先加载月票数据
        ctrl.jumpUrl = urlString
        vc.navigationController?.pushViewController(ctrl, animated: true)
    }
}
