//
//  HomePageViewController.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/21.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomePageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        downloadRecommendData()//下载首页的推荐数据
    }

    //下载首页的推荐数据
    func downloadRecommendData() {
        let downloader = U17Download()
        downloader.delegate = self
        downloader.getWithUrl(homeRecommendUrl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension HomePageViewController: U17DownloadDelegate {
    //下载失败
    func downloader(downloader: U17Download, didFailWithError error: NSError) {
        print(error)
    }
    //下载成功
    func downloader(downloader: U17Download, didFinishWithData data: NSData?) {
        if let tmpData = data{
            //1.json解析
            let recommendModel = HomeRecommend.parseData(tmpData)
            
            //2.显示UI
            let recommendView = HomePageRecommendView(frame: CGRectZero)
            recommendView.model = recommendModel
            view.addSubview(recommendView)
            
            //约束
            recommendView.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 49, 0))
            })
            
            recommendView.jumpClosure = {
                jumpUrl in
                print(jumpUrl)
            }
            
        }else{
            print(data)
        }
    }
}
