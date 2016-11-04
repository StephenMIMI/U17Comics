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
            downloadDetailData()
        }
    }
    var jumpClosure: HomeJumpClosure?
    //数据
    private var comicDetailModel: ComicDetailModel? {
        didSet {
            
            tableView?.reloadData()
        }
    }
    private var tableView: UITableView?
    
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
    
    func handleClickEvent(urlString: String) {
        HomePageService.handleEvent(urlString, onViewController: self)
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
                    [weak self]jumpUrl in
                    self!.handleClickEvent(jumpUrl)
                }
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
            }else {
            
            }
        }
        return height
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let model = comicDetailModel?.data?.returnData
            let cellId = "comicHeaderCellId"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? HomeComicHeaderCell
            if cell == nil {
                cell = NSBundle.mainBundle().loadNibNamed("HomeComicHeaderCell", owner: nil, options: nil).last as? HomeComicHeaderCell
            }
            cell?.jumpClosure = jumpClosure
            cell?.backClosure = {
                self.navigationController?.popViewControllerAnimated(true)
            }
            cell?.model = model
            return cell!
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

