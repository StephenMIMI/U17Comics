//
//  SearchViewController.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/21.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, CustomNavigationProtocol {

    var jumpClosure: HomeJumpClosure?
    private var tableView: UITableView?
    private var listModel: ClassifyData? {
        didSet {
            if listModel?.message == "成功" && listModel?.returnData != nil {
                tableView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = customBgColor
        addTitle("分类页面")
        //初始化tableView
        automaticallyAdjustsScrollViewInsets = false
        tableView = UITableView(frame: CGRectMake(0, 64, screenWidth, screenHeight-64-49), style: .Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = customBgColor
        view.addSubview(tableView!)
        downloadData()//下载数据
    }

    //下载首页的推荐数据
    func downloadData() {
        let downloader = U17Download()
        downloader.delegate = self
        downloader.downloadType = HomeDownloadType.Classify
        downloader.getWithUrl(classifyUrl)
    }
    
    func handleClickEvent(urlString: String, ticketUrl: String?, title: String? = nil) {
        HomePageService.handleEvent(urlString, comicTicket: ticketUrl, title: title, onViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: UITableView的代理
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 0
        if let count = listModel?.returnData?.rankingList?.count {
            num = count/3
            if count%3 > 0 {
                //3个为1行，多1个加1行
                num += 1
            }
        }
        return num
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let range = NSMakeRange(indexPath.row*3, 3)
        if let model = listModel?.returnData?.rankingList {
            let array = NSArray(array: model).subarrayWithRange(range) as! Array<ClassifyRankData>
            let cell = ClassifyCell.createClassifyCellFor(tableView, atIndexPath: indexPath, listModel: array)
            cell.jumpClosure = jumpClosure
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: 下载的代理
extension SearchViewController: U17DownloadDelegate {
    //下载失败
    func downloader(downloader: U17Download, didFailWithError error: NSError) {
        print(error)
    }
    //下载成功
    func downloader(downloader: U17Download, didFinishWithData data: NSData?) {
        if let tmpData = data {
            if downloader.downloadType == HomeDownloadType.Classify {
                let model = ClassifyModel.parseData(tmpData)
                listModel = model.data
                jumpClosure = {
                    [weak self](jumpUrl,ticketUrl,title) in
                    self!.handleClickEvent(jumpUrl, ticketUrl: ticketUrl, title: title)
                }
            }
        }else {
            print(data)
        }
    }
}