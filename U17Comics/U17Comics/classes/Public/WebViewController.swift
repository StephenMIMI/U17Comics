//
//  WebViewController.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/2.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var webView = UIWebView()
    var jumpUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        automaticallyAdjustsScrollViewInsets = false
        webView = UIWebView(frame: CGRectMake(0,64,screenWidth,screenHeight-64))
        view.addSubview(webView)
        
        //创建一个url
        if jumpUrl != nil {
            let url=NSURL(string: jumpUrl!)
            //创建一个请求
            let request=NSURLRequest(URL: url!)
            //加载请求
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
