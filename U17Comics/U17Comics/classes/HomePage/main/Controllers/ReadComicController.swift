//
//  ReadComicController.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/9.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import SnapKit

//阅读漫画页面
class ReadComicController: U17TabViewController, CustomNavigationProtocol{

    //用tableView来实现
    var tableView: UITableView?
    
    var model: ReadComicModel? {
        didSet {
            if model != nil {
                configUI()
            }
        }
    }
    var readComicUrl: String? {
        didSet {
            if readComicUrl != nil {
                downloadData(readComicUrl!)
            }
        }
    }
    var curCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //自定义返回按钮
        let backBtn = UIButton(frame: CGRectMake(0,0,30,30))
        backBtn.setImage(UIImage(named: "nav_back_black"), forState: .Normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), forControlEvents: .TouchUpInside)
        addBarButton(backBtn, position: BarButtonPosition.left)
        // Do any additional setup after loading the view.
    }
    
    func backBtnClick() {
        navigationController?.popViewControllerAnimated(true)
    }

    //下载详情的数据
    func downloadData(urlString: String) {
        let downloader = U17Download()
        downloader.delegate = self
        downloader.downloadType = .ComicDetail
        downloader.getWithUrl(urlString)
    }
    
    func configUI() {
        if tableView == nil {
            automaticallyAdjustsScrollViewInsets = false
            tableView = UITableView(frame: CGRectMake(0, 64, screenWidth, screenHeight-64), style: .Plain)
            tableView?.backgroundColor = UIColor.blackColor()
            tableView?.delegate = self
            tableView?.dataSource = self
            view.addSubview(tableView!)
            tableView?.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: 自定义下载代理
extension ReadComicController: U17DownloadDelegate {
    //下载失败
    func downloader(downloader: U17Download, didFailWithError error: NSError) {
        print(error)
    }
    //下载成功
    func downloader(downloader: U17Download, didFinishWithData data: NSData?) {
        if let tmpData = data {
            model = ReadComicModel.parseData(tmpData)
        }
    }
}

//MARK: scrollView代理
extension ReadComicController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //计算图片压缩比例
        var rate:CGFloat = 1.0
        var height:CGFloat = 0
        let imageData = model?.data?.returnData?.image_list?[indexPath.row]
        if let w = NSNumberFormatter().numberFromString((imageData!.width)!) {
            rate = screenWidth/CGFloat(w)
        }
        //转化高度
        if let h = NSNumberFormatter().numberFromString((imageData!.height)!) {
            height = CGFloat(h)*rate
        }
        return height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //获取image个数
        //Xcode会调用3次方法
        if let totalCount = model?.data?.returnData?.image_list?.count {
            if totalCount > curCount {
                //不够3个，有几个加载几个
                if (totalCount-curCount) > 3 {
                    curCount += 3
                }else {
                    curCount += (totalCount-curCount)
                }
            }
        }
        return curCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "readComicCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? ReadComicCell
        if (nil == cell) {
            cell = NSBundle.mainBundle().loadNibNamed("ReadComicCell", owner: nil, options: nil).last as? ReadComicCell
        }
        let imageData = model?.data?.returnData?.image_list?[indexPath.row]
        cell?.urlString = imageData?.location
        return cell!
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height-scrollView.bounds.size.height-20 {
            tableView?.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}