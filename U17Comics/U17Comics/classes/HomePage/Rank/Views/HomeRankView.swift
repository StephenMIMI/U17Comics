//
//  HomeRankView.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/2.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeRankView: UIView {

    //获取当前view的控制视图
    var viewController: BaseViewController?
    
    private var tableView: UITableView?
    private var headerView: CustomSegCtrl?
    private var scrollView: UIScrollView?
    private var rankTitle: Array<String>? {
        didSet {
            initView()
            if rankLink?.count > 0 {
                downloadData(rankLink![0], downloadType: HomeDownloadType.RankTicket)
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
    
    var jumpClosure: HomeJumpClosure?
    var model: HomeVIPModel? {
        didSet {
            //set方法给model赋值之后会调用这个方法，刷新页面
            tableView?.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        downloadData(homeRankUrl, downloadType: HomeDownloadType.HomeRank)//下载排行标题数据
    }
    
    func initView() {
        self.backgroundColor = customBgColor
        headerView = CustomSegCtrl(frame: CGRectMake(0, 64, screenWidth, 44), titleArray: rankTitle)
        headerView?.delegate = self
        headerView!.backgroundColor = UIColor.whiteColor()
        addSubview(headerView!)
        headerView?.snp_makeConstraints(closure: { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(44)
        })
        
        
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView?.backgroundColor = customBgColor
        tableView?.dataSource = self
        tableView?.delegate = self
        addSubview(tableView!)
        
        tableView?.snp_makeConstraints(closure: { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(headerView!.snp_bottom)
        })
        createSubScroll()
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
        containerView.addSubview(monthTicketView!)
        monthTicketView?.snp_makeConstraints(closure: { (make) in
            make.left.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        rankClickView = HomeMonthTicket()
        containerView.addSubview(rankClickView!)
        rankClickView?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo((monthTicketView?.snp_right)!)
            make.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        rankCommentView = HomeMonthTicket()
        containerView.addSubview(rankCommentView!)
        rankCommentView?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo((rankClickView?.snp_right)!)
            make.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        rankNewView = HomeMonthTicket()
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
    
    func handleClickEvent(urlString: String, ticketUrl: String?) {
        if let tmpViewController = viewController {
            HomePageService.handleEvent(urlString, comicTicket: ticketUrl, onViewController: tmpViewController)
        }
    }
    
    //获取当前显示页面的UIViewController
//    func GetRootViewController() -> UIViewController {
//        var topVC = UIApplication.sharedApplication().keyWindow?.rootViewController
//        while topVC?.presentedViewController != nil {
//            topVC = topVC?.presentedViewController
//        }
//        return topVC!
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: tableView的代理方法
extension HomeRankView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tmpModel = model?.data?.returnData?.comics
        if tmpModel?.count > 0 {
            return (tmpModel?.count)!
        }else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let listModel = model?.data?.returnData?.comics![indexPath.row]
        let cell = HomeVIPCell.createVIPCellFor(tableView, atIndexPath: indexPath, listModel: listModel, type: ViewType.RankTicket)
        cell.jumpClosure = jumpClosure
        return cell
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

}

//MARK: UIScrollView的代理
extension HomeRankView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.bounds.width
        headerView?.selectedIndex = Int(index)
        if index > 0 {
            switch Int(index) {
            case 0:
                downloadData(rankLink![0], downloadType: .RankTicket)
            case 1:
                downloadData(rankLink![1], downloadType: .RankClick)
            case 2:
                downloadData(rankLink![2], downloadType: .RankComment)
            case 3:
                downloadData(rankLink![3], downloadType: .RankNew)
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
                downloadData(rankLink![0], downloadType: .RankTicket)
            case 1:
                downloadData(rankLink![1], downloadType: .RankClick)
            case 2:
                downloadData(rankLink![2], downloadType: .RankComment)
            case 3:
                downloadData(rankLink![3], downloadType: .RankNew)
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
                        let link = homeRankDetail+"argValue=\(rankingList![i].argValue!)"+"&argName=\(rankingList![i].argName!)"+"&page=1"
                        tmpArray.append(rankingList![i].title!)
                        tmpLink.append(link)
                    }
                    rankLink = tmpLink//要写前面 否则rankTitle一赋值就会调用加载URL
                    rankTitle = tmpArray
                }
            }else if downloader.downloadType == HomeDownloadType.RankTicket {
                //1.json解析
                let model = HomeVIPModel.parseData(tmpData)
                monthTicketView!.model = model
                monthTicketView!.jumpClosure = {
                    [weak self](jumpUrl,ticketUrl,title) in
                    self!.handleClickEvent(jumpUrl, ticketUrl: ticketUrl)
                }
            }else if downloader.downloadType == HomeDownloadType.RankClick {
                //点击页面
                let model = HomeVIPModel.parseData(tmpData)
                rankClickView?.model = model
                rankClickView?.viewType = ViewType.RankClick
                rankClickView!.jumpClosure = {
                    [weak self](jumpUrl,ticketUrl,title) in
                    self!.handleClickEvent(jumpUrl, ticketUrl: ticketUrl)
                }
            }else if downloader.downloadType == HomeDownloadType.RankComment {
                //吐槽页面
                let model = HomeVIPModel.parseData(tmpData)
                rankCommentView?.model = model
                rankCommentView?.viewType = ViewType.RankComment
                rankCommentView!.jumpClosure = {
                    [weak self](jumpUrl,ticketUrl,title) in
                    self!.handleClickEvent(jumpUrl, ticketUrl: ticketUrl)
                }
            }else if downloader.downloadType == HomeDownloadType.RankNew {
                //新作页面
                let model = HomeVIPModel.parseData(tmpData)
                rankNewView?.model = model
                rankCommentView?.viewType = ViewType.RankNew
                rankNewView!.jumpClosure = {
                    [weak self](jumpUrl,ticketUrl,title) in
                    self!.handleClickEvent(jumpUrl, ticketUrl: ticketUrl)
                }
            }
        }else {
            print(data)
        }
    }
}

