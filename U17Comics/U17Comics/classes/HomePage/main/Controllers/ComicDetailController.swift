//
//  ComicDetailController.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class ComicDetailController: U17TabViewController {

    var jumpUrl: String? {
        didSet {
            createTableView()
            //先下载月票数据并存储
            downloadTicketData()
            downloadDetailData()
        }
    }
    var ticketUrl: String?
    var jumpClosure: HomeJumpClosure?
    private var tableView: UITableView?
    //数据
    private var comicDetailModel: ComicDetailModel? {
        didSet {
            tableView?.reloadData()
        }
    }
    //月票数据
    private var comicTicketModel: ComicDetailTicket? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    
    func createTableView() {
        automaticallyAdjustsScrollViewInsets = false
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
//        tableView?.backgroundColor = UIColor.init(white: 0.5, alpha: 0.8)
        view.addSubview(tableView!)
        
        tableView?.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(20, 0, 0, 0))
        })
    }
    
    //下载详情的数据
    func downloadDetailData() {
        if jumpUrl != nil {
            let downloader = U17Download()
            downloader.delegate = self
            downloader.downloadType = .ComicDetail
            downloader.getWithUrl(jumpUrl!)
        }
    }
    
    //下载月票的数据
    func downloadTicketData() {
        if ticketUrl != nil {
            let downloader = U17Download()
            downloader.delegate = self
            downloader.downloadType = .ComicTicket
            downloader.getWithUrl(ticketUrl!)
        }
    }
    
    func handleClickEvent(urlString: String, ticketUrl: String?) {
        HomePageService.handleEvent(urlString, comicTicket: ticketUrl, onViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        super.viewWillDisappear(animated)
        
    }

}

extension ComicDetailController: U17DownloadDelegate {
    //下载失败
    func downloader(downloader: U17Download, didFailWithError error: NSError) {
        print(error)
    }
    //下载成功
    func downloader(downloader: U17Download, didFinishWithData data: NSData?) {
        if let tmpData = data {
            if downloader.downloadType == HomeDownloadType.ComicDetail {
                comicDetailModel = ComicDetailModel.parseData(tmpData)
                jumpClosure = {
                    [weak self](jumpUrl,ticketUrl,title) in
                    self!.handleClickEvent(jumpUrl, ticketUrl: ticketUrl)
                }
            }else if downloader.downloadType == HomeDownloadType.ComicTicket {
                    comicTicketModel = ComicDetailTicket.parseData(tmpData)
            }
        }
    }
}

extension ComicDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = 0
        if (comicDetailModel?.data?.returnData?.comic) != nil {
            if indexPath.section == 0 {
                height = 200
            }else if indexPath.section == 1 {
                height = HomeComicChapterCell.heightForChapter((comicDetailModel?.data?.returnData?.chapter_list?.count)!)
            }
        }
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let model = comicDetailModel?.data?.returnData {
            if indexPath.section == 0 {
                let cellId = "comicHeaderCellId"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? HomeComicHeaderCell
                if cell == nil {
                    cell = NSBundle.mainBundle().loadNibNamed("HomeComicHeaderCell", owner: nil, options: nil).last as? HomeComicHeaderCell
                }
                
                cell?.jumpClosure = jumpClosure
                cell?.backClosure = { [weak self] in
                    self!.navigationController?.popViewControllerAnimated(true)
                }
                cell?.ticketModel = comicTicketModel?.data?.returnData
                cell?.model = model
                return cell!
            }else if indexPath.section == 1 {
                let cellId = "comicChapterCellId"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? HomeComicChapterCell
                if cell == nil {
                    cell = HomeComicChapterCell()
                }
                cell?.jumpClosure = jumpClosure
                cell?.model = model
                return cell!
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        if section == 0 {
            height = 0
        }else if section == 1 {
            height = 44
        }
        return height
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        if section == 1 {
            height = 44
        }
        return height
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let cell = HomeComicHeaderView.init(frame: CGRectMake(0,0,screenWidth,44))
            return cell
        }
        return nil
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let cell = HomeComicChapterFooter.init(frame: CGRectMake(0,0,screenWidth,44))
            cell.model = comicTicketModel?.data?.returnData?.comment
            return cell
        }
        return nil
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let height: CGFloat = 44
        if scrollView.contentOffset.y >= height {
            scrollView.contentInset = UIEdgeInsetsMake(-height, 0, 0, 0)
        }else if scrollView.contentOffset.y > 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
        }
    }
}

