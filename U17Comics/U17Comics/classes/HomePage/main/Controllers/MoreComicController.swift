//
//  MoreComicController.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class MoreComicController: U17TabViewController {

    //请求的url
    var urlString: String? {
        didSet {
            createTableView()
            downloadDetailData()
        }
    }
    var jumpClosure: HomeJumpClosure?
    var viewType: ViewType = ViewType.Subscribe
    //数据
    private var detailData: HomeVIPModel? {
        didSet {
            
            tableView?.reloadData()
        }
    }
    private var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    func createTableView() {
        automaticallyAdjustsScrollViewInsets = false
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
        
        tableView?.snp_makeConstraints(closure: { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(64)
        })
    }
    
    //下载详情的数据
    func downloadDetailData() {
        if urlString != nil {
            let downloader = U17Download()
            downloader.delegate = self
            downloader.downloadType = HomeDownloadType.MoreComic
            downloader.getWithUrl(urlString!)
        }
    }
    
    func handleClickEvent(urlString: String) {
        HomePageService.handleEvent(urlString, onViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: downloader的代理
extension MoreComicController: U17DownloadDelegate {
    //下载失败
    func downloader(downloader: U17Download, didFailWithError error: NSError) {
        print(error)
    }
    //下载成功
    func downloader(downloader: U17Download, didFinishWithData data: NSData?) {
        if let tmpData = data {
            if downloader.downloadType == HomeDownloadType.MoreComic {
                detailData = HomeVIPModel.parseData(tmpData)
                jumpClosure = {
                    [weak self]jumpUrl in
                    self!.handleClickEvent(jumpUrl)
                }
            }
        }
    }
}

//MARK: tableView的代理
extension MoreComicController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tmpModel = detailData?.data?.returnData?.comics
        if tmpModel?.count > 0 {
            return (tmpModel?.count)!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let listModel = detailData?.data?.returnData?.comics {
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
