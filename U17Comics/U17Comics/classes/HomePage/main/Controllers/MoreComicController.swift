//
//  MoreComicController.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class MoreComicController: U17TabViewController, CustomNavigationProtocol {

    //请求的url
    var urlString: String? {
        didSet {
            createTableView()
            downloadDetailData(urlString)
        }
    }
    var jumpClosure: HomeJumpClosure?
    var viewType: ViewType = ViewType.Subscribe
    //标题文字
    var titleStr: String?
    //数据重载就刷新页面
    private var detailData: HomeVIPModel? {
        didSet {
            
            tableView?.reloadData()
        }
    }
    //更多页面筛选框
    private var index: Int? {
        didSet {
            if index != oldValue {
                if cataLabel != nil && urlString != nil {
                    cataLabel?.text = titleArray[index!]
                    var strArray = urlString?.componentsSeparatedByString("&")
                    //更新url
                    if strArray != nil {
                        strArray![2] = "argCon=\(index!+1)"
                        var newUrl = strArray![0]
                        for i in 1..<(strArray?.count)! {
                            newUrl += "&\(strArray![i])"
                        }
                        downloadDetailData(newUrl)
                        if titleArray[index!] == "点击" {
                            viewType = .RankClick
                        }else if titleArray[index!] == "更新" {
                            viewType = .Subscribe
                        }else if titleArray[index!] == "收藏" {
                            viewType = .Collection
                        }
                    }
                }
            }
        }
    }
    //定义筛选视图是否隐藏
    private var viewHidden: Bool = true
    private var tableView: UITableView?
    private var cataLabel: UILabel?
    private var sortView: UIView?//下拉框视图
    private var coverView: UIView?//点击下拉后填充屏幕视图
    let titleArray = ["点击","更新","收藏"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tmpTitle = titleStr {
            addTitle(tmpTitle)
        }
        //自定义返回按钮
        let backBtn = UIButton(frame: CGRectMake(0,0,30,30))
        backBtn.setImage(UIImage(named: "nav_back_black"), forState: .Normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), forControlEvents: .TouchUpInside)
        addBarButton(backBtn, position: BarButtonPosition.left)
        
        //自定义下拉框按钮
        let rightBtn = UIButton(frame: CGRectMake(0,0,45,40))
        rightBtn.addTarget(self, action: #selector(rightBtnClick), forControlEvents: .TouchUpInside)
        addBarButton(rightBtn, position: BarButtonPosition.right)
        cataLabel = UILabel(frame: CGRectMake(0,0,25,40))
        cataLabel?.font = UIFont.systemFontOfSize(12)
        cataLabel?.textColor = UIColor.lightGrayColor()
        cataLabel?.text = "更新"
        rightBtn.addSubview(cataLabel!)
        
        let downArrow = UIImageView(frame: CGRectMake(25,5,20,30))
        downArrow.image = UIImage(named: "arrowdown")
        rightBtn.addSubview(downArrow)
    }

    func rightBtnClick() {
        if coverView == nil {
            coverView = UIView(frame: CGRectMake(0,20,screenWidth,screenHeight))
            //bug这里的手势无法响应
            coverView?.backgroundColor = UIColor.clearColor()
            view.addSubview(coverView!)
            let tap = UIGestureRecognizer(target: self, action: #selector(coverTap))
            tap.cancelsTouchesInView = false
            tap.delegate = self
            coverView?.addGestureRecognizer(tap)
        }
        if coverView != nil && sortView == nil {
            sortView = UIView(frame: CGRectMake(screenWidth-15-50,44,50,90))
            sortView?.backgroundColor = UIColor.whiteColor()
            sortView?.layer.borderWidth = 1
            sortView?.layer.borderColor = UIColor.lightGrayColor().CGColor
            sortView?.layer.shadowOffset = CGSizeMake(1, 1)

            for i in 0..<3 {
                let btn = UIButton(type: UIButtonType.Custom)
                btn.frame = CGRectMake(0,CGFloat(i)*30,45,30)
                btn.addTarget(self, action: #selector(sortClick(_:)), forControlEvents: .TouchUpInside)
                btn.tag = 100+i
                sortView?.addSubview(btn)
                let label = UILabel(frame: btn.bounds)
                label.text = titleArray[i]
                label.textColor = UIColor.lightGrayColor()
                label.textAlignment = .Center
                label.font = UIFont.systemFontOfSize(12)
                btn.addSubview(label)
            }
            coverView!.addSubview(sortView!)
        }
        viewHidden = !viewHidden
        coverView?.hidden = viewHidden
    }
    
    //背部蒙版点击隐藏
    func coverTap() {
        print(11)
        viewHidden = !viewHidden
        coverView?.hidden = viewHidden
    }
    
    func sortClick(btn: UIButton) {
        index = btn.tag-100
        viewHidden = !viewHidden
        coverView?.hidden = viewHidden
    }
    
    func backBtnClick() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func createTableView() {
        automaticallyAdjustsScrollViewInsets = false
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = customBgColor
        view.addSubview(tableView!)
        
        tableView?.snp_makeConstraints(closure: { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(64)
        })
    }
    
    //下载详情的数据
    func downloadDetailData(urlString: String?) {
        if urlString != nil {
            let downloader = U17Download()
            downloader.delegate = self
            downloader.downloadType = HomeDownloadType.MoreComic
            downloader.getWithUrl(urlString!)
        }
    }
    
    func handleClickEvent(urlString: String, ticketUrl: String?) {
        HomePageService.handleEvent(urlString, comicTicket: ticketUrl, onViewController: self)
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
                    [weak self](jumpUrl,ticketUrl,title) in
                    self!.handleClickEvent(jumpUrl, ticketUrl: ticketUrl)
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
            cell.backgroundColor = customBgColor
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

//MARK: 实现点击事件代理
extension MoreComicController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        //不接受uiview上的button
        if ((touch.view?.isKindOfClass(UIButton.self)) != nil) {
            return false
        }
        return true
    }
}
