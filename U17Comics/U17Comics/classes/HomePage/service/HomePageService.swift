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
            //处理显示更多页面
            MoreComicsView.handleEvent(urlString, onViewController: vc)
        }else if urlString.hasPrefix(comicsDetailUrl) {
            //处理漫画详情页面
            ComicDetailView.handleEvent(urlString, onViewController: vc)
        }else if urlString.hasPrefix("http://"){
            //处理网页跳转页面
            WebViewService.handleEvent(urlString, onViewController: vc)
        }else {
            
            print(urlString)
        }
    }
}
