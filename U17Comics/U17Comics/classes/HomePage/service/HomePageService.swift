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
    
    class func handleEvent(urlString: String, comicTicket: String? = nil, title: String? = nil, onViewController vc: UIViewController) {
        if urlString.hasPrefix(homeMoreUrlNoArg) {
            //处理显示更多页面
            //print(urlString)
            MoreComicsView.handleEvent(urlString, title: title, onViewController: vc)
        }else if urlString.hasPrefix(comicsDetailUrl) {
            //处理漫画详情页面
            //print(urlString)
            //print(comicTicket!)
            ComicDetailView.handleEvent(urlString, comicTicket: comicTicket, onViewController: vc)
        }else if urlString.hasPrefix("http://") {
            //处理网页跳转页面
            WebViewService.handleEvent(urlString, title: title, onViewController: vc)
        }else {
            
            print(urlString)
        }
    }
}
