//
//  HomeRankView.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/2.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import MJRefresh

class HomeRankView: UIView {

    //获取当前view的控制视图
    var viewController: BaseViewController?
    
    private var headerView: CustomSegCtrl?
    private var scrollView: UIScrollView?
    private var rankTitle: Array<String>?{
        didSet {
            if rankLink?.count > 0 {
                initHeaderView()
            }
        }
    }
    private var rankLink: Array<String>?
    
    //排行-月票页面
    var monthTicketView: HomeMonthTicket?
    //排行-点击页面
    var rankClickView: HomeMonthTicket?
    //排行-吐槽页面
    var rankCommentView: HomeMonthTicket?
    //排行-新作页面
    var rankNewView: HomeMonthTicket?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = customBgColor
        downloadData(homeRankUrl, downloadType: HomeDownloadType.HomeRank)//下载排行标题数据
    }
    
    func initHeaderView() {
        if headerView == nil {
            headerView = CustomSegCtrl(frame: CGRectMake(0, 64, screenWidth, 44), titleArray: rankTitle)
            headerView?.delegate = self
            headerView!.backgroundColor = UIColor.whiteColor()
            addSubview(headerView!)
            headerView?.snp_makeConstraints(closure: { (make) in
                make.left.right.top.equalTo(self)
                make.height.equalTo(44)
            })
        }
        createSubScroll()
        
        //初始化月票页面
        monthTicketView?.downloadType = HomeDownloadType.RankTicket
        monthTicketView?.urlString = rankLink?[0]
    }
    
    func downloadData(url: String, downloadType: HomeDownloadType) {
        let downloader = U17Download()
        downloader.delegate = self
        downloader.downloadType = downloadType
        downloader.getWithUrl(url)
    }
    
    //创建子滚动视图
    func createSubScroll() {
        scrollView = UIScrollView()
        scrollView?.backgroundColor = customBgColor
        scrollView?.pagingEnabled = true
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.delegate = self
        addSubview(scrollView!)
        
        scrollView?.snp_makeConstraints(closure: { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(headerView!.snp_bottom)
        })
        
        //容器视图
        let containerView = UIView.createView()
        scrollView?.addSubview(containerView)
        containerView.snp_makeConstraints { (make) in
            make.edges.equalTo(scrollView!)
            make.height.equalTo(scrollView!)
        }
        
        //添加子视图
        monthTicketView = HomeMonthTicket()
        monthTicketView?.viewController = viewController
        containerView.addSubview(monthTicketView!)
        monthTicketView?.snp_makeConstraints(closure: { (make) in
            make.left.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        rankClickView = HomeMonthTicket()
        rankClickView?.viewController = viewController
        containerView.addSubview(rankClickView!)
        rankClickView?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo((monthTicketView?.snp_right)!)
            make.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        rankCommentView = HomeMonthTicket()
        rankCommentView?.viewController = viewController
        containerView.addSubview(rankCommentView!)
        rankCommentView?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo((rankClickView?.snp_right)!)
            make.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        rankNewView = HomeMonthTicket()
        rankNewView?.viewController = viewController
        containerView.addSubview(rankNewView!)
        rankNewView?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo((rankCommentView?.snp_right)!)
            make.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        containerView.snp_makeConstraints { (make) in
            make.right.equalTo(rankNewView!)
        }
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: UIScrollView的代理
extension HomeRankView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.bounds.width
        headerView?.selectedIndex = Int(index)
        if index >= 0 {
            switch Int(index) {
            case 0:
                monthTicketView?.downloadType = .RankTicket
                monthTicketView?.urlString = rankLink?[0]
            case 1:
                rankClickView?.downloadType = .RankClick
                rankClickView?.urlString = rankLink?[1]
            case 2:
                rankCommentView?.downloadType = .RankComment
                rankCommentView?.urlString = rankLink?[2]
            case 3:
                rankNewView?.downloadType = .RankNew
                rankNewView?.urlString = rankLink?[3]
            default:
                break
            }
        }
    }
}

//MARK: CustomSegCtrl代理
extension HomeRankView: CustomSegCtrlDelegate {
    func segmentCtrl(segCtrl: CustomSegCtrl, didClickBtnAtIndex index: Int) {
        if rankLink?.count > 0 {
            switch index {
            case 0:
                monthTicketView?.downloadType = .RankTicket
                monthTicketView?.urlString = rankLink?[0]
            case 1:
                rankClickView?.downloadType = .RankClick
                rankClickView?.urlString = rankLink?[1]
            case 2:
                rankCommentView?.downloadType = .RankComment
                rankCommentView?.urlString = rankLink?[2]
            case 3:
                rankNewView?.downloadType = .RankNew
                rankNewView?.urlString = rankLink?[3]
            default:
                break
            }
        }
        scrollView?.setContentOffset(CGPointMake(CGFloat(index)*screenWidth, 0), animated: true)
    }
    
}

//MARK: DownloadDelegate方法
extension HomeRankView: U17DownloadDelegate {
    //下载失败
    func downloader(downloader: U17Download, didFailWithError error: NSError) {
        print(error)
    }
    //下载成功
    func downloader(downloader: U17Download, didFinishWithData data: NSData?) {
        if let tmpData = data {
            if downloader.downloadType == HomeDownloadType.HomeRank {
                //排行标题
                let model = HomeRankTitleModel.parseData(tmpData)
                let rankingList = model.data?.returnData?.rankinglist
                //动态获取标题
                if rankingList?.count > 0 {
                    var tmpArray = Array<String>()
                    var tmpLink = Array<String>()
                    for i in 0..<(rankingList?.count)! {
                        let link = homeRankDetail+"argValue=\(rankingList![i].argValue!)"+"&argName=\(rankingList![i].argName!)"+"&page="
                        tmpArray.append(rankingList![i].title!)
                        tmpLink.append(link)
                    }
                    rankLink = tmpLink//要写前面 否则rankTitle一赋值就会调用加载URL
                    rankTitle = tmpArray
                }
            }
        }else {
            print(data)
        }
    }
}