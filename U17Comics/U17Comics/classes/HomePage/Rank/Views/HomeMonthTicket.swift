//
//  HomeMonthTicket.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import MJRefresh

class HomeMonthTicket: UIView {

    private var tableView: UITableView?
    //选中页面
    var downloadType: HomeDownloadType = HomeDownloadType.RankTicket
    //显示网址
    var urlString: String?
    var viewType: ViewType = ViewType.RankTicket
    var jumpClosure: HomeJumpClosure?
    var model: HomeVIPModel? {
        didSet {
            tableView?.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = customBgColor
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView?.backgroundColor = customBgColor
        tableView?.dataSource = self
        tableView?.delegate = self
        addSubview(tableView!)
        
        tableView?.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self)
        })
        addRefresh({ [weak self] in
//            self!.currentPage = 1
//            self!.downloadData(self!.rankLink![(self!.headerView?.selectedIndex)!]+"\(self!.currentPage)", downloadType: self!.downloadType)
        }) { [weak self] in
//            self?.currentPage += 1
//            self!.downloadData(self!.rankLink![(self!.headerView?.selectedIndex)!]+"\(self!.currentPage)", downloadType: self!.downloadType)
        }
    }
    
    func downloadData(url: String, downloadType: HomeDownloadType) {
        let downloader = U17Download()
        downloader.delegate = self
        downloader.downloadType = downloadType
        print(url)
        downloader.getWithUrl(url)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeMonthTicket: UITableViewDelegate, UITableViewDataSource {
    
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
        let cell = HomeVIPCell.createVIPCellFor(tableView, atIndexPath: indexPath, listModel: listModel, type: viewType)
        cell.jumpClosure = jumpClosure
        return cell
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

//MARK: DownloadDelegate方法
extension HomeMonthTicket: U17DownloadDelegate {
    //下载失败
    func downloader(downloader: U17Download, didFailWithError error: NSError) {
        print(error)
    }
    //下载成功
    func downloader(downloader: U17Download, didFinishWithData data: NSData?) {
        if let tmpData = data {
            if tableView != nil {
                //self.tableView!.mj_header.endRefreshing()
                //self.tableView!.mj_footer.endRefreshing()
            }
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

//刷新页面的代理
extension HomeMonthTicket: CustomAddRefreshProtocol {
    func addRefresh(header: (()->())?, footer:(()->())?) {
        if header != nil && tableView != nil {
            tableView!.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                header!()
            })
        }
        if footer != nil && tableView != nil {
            tableView!.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                footer!()
            })
        }
    }
}