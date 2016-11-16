//
//  ComicDetailController.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class ComicDetailController: U17TabViewController {

    //获取文件存放路径
    let filePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingString("comicReadedData.data")
    var jumpUrl: String? {
        didSet {
            createTableView()
            //先下载月票数据并存储
            downloadTicketData()
            downloadDetailData()
            //initLocal()
        }
    }
    var comicId: String?
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
    private var readComicModel: ReadComicModel?
    private var readComicClosure: ReadComicClosure?
    //暂时接受chapterCell传递的名字和ID
    private var chapterName: String?
    private var chapterId: String? {
        didSet {
            tableView?.reloadData()
            //updateLocal()
        }
    }
    //暂时接受存放排序值
    private var cellSortValue: Bool?
    private var localArray: ComicReadedModelArray?
    
    //首次跳转到这个页面，从本地读取信息并初始化数组
    func initLocal() {
        let data = NSData(contentsOfFile: filePath)
        if data != nil {
            let decode = NSKeyedUnarchiver(forReadingWithData: data!)
            localArray = decode.decodeObjectForKey("readedArray") as? ComicReadedModelArray
            decode.finishDecoding()
        }
        if localArray?.readedArray == nil {
            localArray = ComicReadedModelArray()
        }
        if jumpUrl != nil {
            var strArray = jumpUrl?.componentsSeparatedByString("?comicid=")
            if strArray?.count > 1 {
                comicId = strArray![1]
            }
        }
        updateLocal()
    }
    
    func updateLocal() {
        //定义一个局部变量，判断是否更新还是插入
        var update: Bool = true
        let tmpModel = ComicReadedModel(comicId: comicId, chapterName: chapterName, chapterId: chapterId)
        if let count = localArray?.readedArray?.count {
            for i in 0..<count {
                if let tmpId = localArray?.readedArray?[i].comicId {
                    if tmpId == comicId {
                        //原来已经有的漫画 就更新
                        self.chapterId = localArray?.readedArray![i].chapterId
                        self.chapterName = localArray?.readedArray![i].chapterName
                        //原来已经有的漫画 就更新,但是第一次加载就不更新
                        if chapterId != nil {
                            localArray?.readedArray![i] = tmpModel
                            update = false
                        }
                        break
                    }
                }
            }
        }
        if update == true && chapterId != nil {
            localArray?.readedArray!.append(tmpModel)
        }
        print(localArray?.readedArray?[0].chapterId)
        let data = NSMutableData()
        let code = NSKeyedArchiver.init(forWritingWithMutableData: data)
        code.encodeObject(localArray, forKey: "readedArray")
        code.finishEncoding()
        data.writeToFile(filePath, atomically: false)
    }
    
    func createTableView() {
        automaticallyAdjustsScrollViewInsets = false
        if tableView == nil {
            tableView = UITableView(frame: CGRectZero, style: .Plain)
            tableView?.delegate = self
            tableView?.dataSource = self
            view.addSubview(tableView!)
            
            tableView?.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(view).inset(UIEdgeInsetsMake(20, 0, 0, 0))
            })
        }

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
    
    func handleReadComic(urlString: String) {
        let readComicView = ReadComicController()
        readComicView.readComicUrl = urlString
        navigationController?.pushViewController(readComicView, animated: true)
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
                //第一次进入漫画页面，就会给漫画开始按钮一个第一章的值
                if let tmpModel = comicDetailModel?.data?.returnData?.chapter_list {
                    chapterId = tmpModel[0].chapter_id
                    //chapterName = tmpModel[0].name
                }
                jumpClosure = {
                    [weak self](jumpUrl,ticketUrl,title) in
                    self!.handleClickEvent(jumpUrl, ticketUrl: ticketUrl)
                }
                readComicClosure = {[weak self](urlString,chapterName,chapterId) in
                    self!.handleReadComic(urlString)
                    self!.chapterName = chapterName
                    self!.chapterId = chapterId
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
                cell?.sortValueClosure = {
                    self.cellSortValue = $0
                }
                cell?.sortBool = cellSortValue
                cell?.controller = self
                cell?.jumpClosure = jumpClosure
                cell?.readComicClosure = readComicClosure
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

    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let cell = HomeComicHeaderView.init(frame: CGRectMake(0,0,screenWidth,44))
            cell.chapterName = chapterName
            cell.chapterId = chapterId
            cell.controller = self
            cell.readComicClosure = readComicClosure
            return cell
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        if section == 1 {
            height = 44
        }
        return height
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let cell = HomeComicChapterFooter.init(frame: CGRectMake(0,0,screenWidth,44))
            cell.model = comicTicketModel?.data?.returnData?.comment
            cell.controller = self
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

