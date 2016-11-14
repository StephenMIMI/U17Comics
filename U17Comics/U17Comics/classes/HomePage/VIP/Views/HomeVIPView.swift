//
//  HomeVIPView.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/1.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import MJRefresh

class HomeVIPView: UIView {

    private var tableView: UITableView?
    //当前页数
    private var currentPage: Int = 1
    var downloadType: HomeDownloadType?
    var viewType: ViewType = ViewType.RankTicket
    var jumpClosure: HomeJumpClosure?
    var model: Array<HomeVIPComics>? {
        didSet {
            //set方法给model赋值之后会调用这个方法，刷新页面
            tableView?.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        addSubview(tableView!)
        
        tableView?.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self)
        })
        addRefresh({ 
            [weak self] in
            self!.currentPage = 1
            self!.downloadData()
            }) { 
            [weak self] in
            self!.currentPage += 1
            self!.downloadData()
        }
    }
    
    func downloadData() {
        let downloader = U17Download()
        downloader.delegate = self
        if downloadType == HomeDownloadType.HomeVIP {
            let tmpUrl = String(format: homeMoreUrl, 14,"topic",2)
            downloader.getWithUrl(tmpUrl+"\(currentPage)")
        }else if downloadType == HomeDownloadType.HomeSubscribe {
            let tmpUrl = String(format: homeMoreUrl, 12,"topic",2)
            downloader.getWithUrl(tmpUrl+"\(currentPage)")
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: tableView的代理方法
extension HomeVIPView: UITableViewDataSource, UITableViewDelegate {
    
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

//MARK: 网址请求代理
extension HomeVIPView: U17DownloadDelegate {
    //下载失败
    func downloader(downloader: U17Download, didFailWithError error: NSError) {
        print(error)
    }
    //下载成功
    func downloader(downloader: U17Download, didFinishWithData data: NSData?) {
        if let tmpData = data {
            
            self.tableView!.mj_header.endRefreshing()
            self.tableView!.mj_footer.endRefreshing()
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
        }else {
            print(data)
        }
    }
}

//刷新页面的代理
extension HomeVIPView: CustomAddRefreshProtocol {
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
