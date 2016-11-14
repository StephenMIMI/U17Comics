//
//  HomePageViewController.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/21.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit


class HomePageViewController: BaseViewController {

    //滚动视图
    private var scrollView: UIScrollView?
    //选择控件
    private var segCtrl: CustomSegCtrl?
    //推荐视图
    var recommendView: HomePageRecommendView?
    //VIP视图
    var VIPView: HomeVIPView?
    //订阅视图
    var subscribeView: HomeVIPView?
    //排行视图
    var rankView: HomeRankView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = customBgColor
        automaticallyAdjustsScrollViewInsets = false
        
        //选择控件
        let frame = CGRectMake(0, 0, screenWidth-120, 44)
        segCtrl = CustomSegCtrl(frame: frame, titleArray: ["推荐","VIP","订阅","排行"])
        segCtrl!.delegate = self
        navigationItem.titleView = segCtrl
        
        createHomePage()//创建滚动视图
        downloadRecommendData()//下载首页的推荐数据
        downloadVIPData()//下载VIP页面的数据
        downloadSubscribeData()//下载订阅页面的数据
        

    }
    
    //创建首页滚动视图
    func createHomePage() {
        scrollView = UIScrollView()
        scrollView?.backgroundColor = customBgColor
        scrollView?.pagingEnabled = true
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.delegate = self
        view.addSubview(scrollView!)
        
        scrollView?.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 49, 0))
        }
        
        //容器视图
        let containerView = UIView.createView()
        scrollView!.addSubview(containerView)
        containerView.snp_makeConstraints { (make) in
            make.edges.equalTo(scrollView!)
            make.height.equalTo(scrollView!)
        }
        
        //添加子视图
        //1.推荐视图
        recommendView = HomePageRecommendView()
        containerView.addSubview(recommendView!)
        recommendView?.snp_makeConstraints(closure: { (make) in
            make.left.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        //2.VIP视图
        VIPView = HomeVIPView()
        containerView.addSubview(VIPView!)
        VIPView?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo((recommendView?.snp_right)!)
            make.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        //3.订阅视图
        subscribeView = HomeVIPView()
        containerView.addSubview(subscribeView!)
        subscribeView?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo((VIPView?.snp_right)!)
            make.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
            
        })
        
        //3.排行视图
        rankView = HomeRankView()
        //将当前视图控制器传递过去
        rankView?.viewController = self
        containerView.addSubview(rankView!)
        rankView?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo((subscribeView?.snp_right)!)
            make.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
            
        })
        
        //修改容器视图的大小
        containerView.snp_makeConstraints { (make) in
            make.right.equalTo(rankView!)
        }

    }
    
    //下载首页的推荐数据
    func downloadRecommendData() {
        let downloader = U17Download()
        downloader.delegate = self
        downloader.downloadType = HomeDownloadType.HomeRecommend
        downloader.getWithUrl(homeRecommendUrl)
    }
    
    func downloadVIPData() {
        let downloader = U17Download()
        downloader.delegate = self
        downloader.downloadType = HomeDownloadType.HomeVIP
        let tmpUrl = String(format: homeMoreUrl, 14,"topic",2)
        downloader.getWithUrl(tmpUrl+"1")
    }
    
    func downloadSubscribeData() {
        let downloader = U17Download()
        downloader.delegate = self
        downloader.downloadType = HomeDownloadType.HomeSubscribe
        let tmpUrl = String(format: homeMoreUrl, 12,"topic",2)
        downloader.getWithUrl(tmpUrl+"1")
    }
    
    func handleClickEvent(urlString: String, ticketUrl: String?, title: String? = nil) {
        HomePageService.handleEvent(urlString, comicTicket: ticketUrl, title: title, onViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: 网址请求代理
extension HomePageViewController: U17DownloadDelegate {
    //下载失败
    func downloader(downloader: U17Download, didFailWithError error: NSError) {
        print(error)
    }
    //下载成功
    func downloader(downloader: U17Download, didFinishWithData data: NSData?) {
        if let tmpData = data {
            if downloader.downloadType == HomeDownloadType.HomeRecommend {
                //1.json解析
                let model = HomeRecommend.parseData(tmpData)
                recommendView!.model = model
                recommendView!.jumpClosure = {
                    [weak self](jumpUrl,ticketUrl,title) in
                    self!.handleClickEvent(jumpUrl, ticketUrl: ticketUrl, title: title)
                }
            }else if downloader.downloadType == HomeDownloadType.HomeVIP {
                //VIP页面
                if let model = HomeVIPModel.parseData(tmpData).data?.returnData?.comics {
                    VIPView?.model = model
                    VIPView?.downloadType = .HomeVIP
                    VIPView?.viewType = ViewType.VIP
                    VIPView!.jumpClosure = {
                        [weak self](jumpUrl,ticketUrl,title) in
                        self!.handleClickEvent(jumpUrl, ticketUrl: ticketUrl)
                    }
                }
            }else if downloader.downloadType == HomeDownloadType.HomeSubscribe {
                //分类页面
                if let model = HomeVIPModel.parseData(tmpData).data?.returnData?.comics {
                    subscribeView?.model = model
                    VIPView?.downloadType = .HomeSubscribe
                    subscribeView?.viewType = ViewType.Subscribe
                    subscribeView!.jumpClosure = {
                        [weak self](jumpUrl,ticketUrl,title) in
                        self!.handleClickEvent(jumpUrl, ticketUrl: ticketUrl)
                    }
                }
            }
        }else {
            print(data)
        }
    }
}
//MARK: CustomSegCtrl代理
extension HomePageViewController: CustomSegCtrlDelegate {
    func segmentCtrl(segCtrl: CustomSegCtrl, didClickBtnAtIndex index: Int) {
        scrollView?.setContentOffset(CGPointMake(CGFloat(index)*screenWidth, 0), animated: true)
        if index == 1 {
            VIPView?.downloadType = .HomeVIP
        }else if index == 2 {
            subscribeView?.downloadType = .HomeSubscribe
        }
    }
}
//MARK: UIScrollView的代理
extension HomePageViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.bounds.width
        segCtrl?.selectedIndex = Int(index)
        if index == 1 {
            VIPView?.downloadType = .HomeVIP
        }else if index == 2 {
            subscribeView?.downloadType = .HomeSubscribe
        }
    }
}