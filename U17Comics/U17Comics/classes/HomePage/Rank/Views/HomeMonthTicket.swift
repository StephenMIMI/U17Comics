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

    //获取当前view的控制视图
    var viewController: BaseViewController?
    
    private var currentPage: Int = 1
    private var tableView: UITableView?
    //选中页面
    var downloadType: HomeDownloadType = HomeDownloadType.RankTicket
    //显示网址
    var urlString: String? {
        didSet {
            if urlString != nil {
                downloadData(urlString!+"\(currentPage)", downloadType: downloadType)
            }
        }
    }
    var viewType: ViewType = ViewType.RankTicket
    var jumpClosure: HomeJumpClosure?
    var model: Array<HomeVIPComics>? {
        didSet {
            tableView?.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = customBgColor
        if tableView == nil {
            tableView = UITableView(frame: CGRectZero, style: .Plain)
            tableView?.backgroundColor = customBgColor
            tableView?.dataSource = self
            tableView?.delegate = self
            addSubview(tableView!)
            
            tableView?.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(self)
            })
            jumpClosure = {
                [weak self](jumpUrl,ticketUrl,title) in
                self!.handleClickEvent(jumpUrl, ticketUrl: ticketUrl)
            }
            
            addRefresh({ [weak self] in
                self!.currentPage = 1
                self!.downloadData(self!.urlString!+"\(self!.currentPage)", downloadType: self!.downloadType)
                    }) { [weak self] in
                    self!.currentPage += 1
                    self!.downloadData(self!.urlString!+"\(self!.currentPage)", downloadType: self!.downloadType)
                }
        }
        
    }
    
    func downloadData(url: String, downloadType: HomeDownloadType) {
        let downloader = U17Download()
        downloader.delegate = self
        downloader.downloadType = downloadType
        downloader.getWithUrl(url)
    }
    
    func handleClickEvent(urlString: String, ticketUrl: String?) {
        if let tmpViewController = viewController {
            HomePageService.handleEvent(urlString, comicTicket: ticketUrl, onViewController: tmpViewController)
        }
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
        if let tmpModel = model {
            return tmpModel.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let listModel = model {
            let cell = HomeVIPCell.createVIPCellFor(tableView, atIndexPath: indexPath, listModel: listModel[indexPath.row], type: viewType)
            cell.jumpClosure = jumpClosure
            return cell
        }
        return UITableViewCell()
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
                self.tableView!.mj_header.endRefreshing()
                self.tableView!.mj_footer.endRefreshing()
            }
            //1.json解析
            if let tmpModel = HomeVIPModel.parseData(tmpData).data?.returnData?.comics {
                if currentPage == 1 {
                    model = tmpModel
                }else {
                    let tmpArray = NSMutableArray(array: model!)
                    tmpArray.addObjectsFromArray(tmpModel)
                    model = NSArray(array: tmpArray) as? Array<HomeVIPComics>
                }
            }
            if downloader.downloadType == HomeDownloadType.RankTicket {
                viewType = ViewType.RankTicket
            }else if downloader.downloadType == HomeDownloadType.RankClick {
                //点击页面
                viewType = ViewType.RankClick
            }else if downloader.downloadType == HomeDownloadType.RankComment {
                //吐槽页面
                viewType = ViewType.RankComment
            }else if downloader.downloadType == HomeDownloadType.RankNew {
                //新作页面
                viewType = ViewType.RankNew
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
