//
//  HomePageService.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
//工厂模式
class HomePageService: NSObject {
    
    class func handleEvent(urlString: String, onViewController vc: UIViewController) {
        if urlString.hasPrefix(homeMoreUrl) {
            MoreComicsView.handleMoreComics(urlString, onViewController: vc)
        }else if urlString.hasPrefix(comicsDetailUrl) {
            print(urlString)
        }else {
            WebViewService.handleWebEvent(urlString, onViewController: vc)
        }
    }
}
