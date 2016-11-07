//
//  WebViewController.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/2.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class WebViewController: U17TabViewController ,CustomNavigationProtocol{

    var webView = UIWebView()
    var jumpUrl: String?
    var webTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tmpTitle = webTitle {
            addTitle(tmpTitle)
        }
        //自定义返回按钮
        let backBtn = UIButton(frame: CGRectMake(0,0,30,30))
        backBtn.setImage(UIImage(named: "nav_back_black"), forState: .Normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), forControlEvents: .TouchUpInside)
        addBarButton(backBtn, position: BarButtonPosition.left)
        
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

    func backBtnClick() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
