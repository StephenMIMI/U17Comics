//
//  HomePageRecommendView.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/25.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import MJRefresh

protocol CustomAddRefreshProtocol: NSObjectProtocol {
    func addRefresh(header: (()->())?, footer:(()->())?)
}

public typealias HomeJumpClosure = ((String, String?, String?) -> Void)

//定义首页推荐列表的类型
public enum HomeComicType: Int {
    case Comics = 1  //漫画类型section
    case Event = 5  //漫画活动
    case Hot = 3    //热门漫画
}

class HomePageRecommendView: UIView {

    var jumpClosure: HomeJumpClosure?
    //数据
    var model: HomeRecommend? {
        didSet {
            //set方法给model赋值之后会调用这个方法，刷新页面
            tableView?.reloadData()
        }
    }
    private var tableView: UITableView?
    //当前页数
    private var currentPage: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //创建表格视图
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = customBgColor
        
        addSubview(tableView!)
        
        tableView?.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self)
        })
        addRefresh({ 
            [weak self] in
            self!.currentPage = 1
            self!.downloadData()
            }, footer: nil)
    }
    
    func downloadData() {
        let downloader = U17Download()
        downloader.delegate = self
        downloader.downloadType = HomeDownloadType.HomeRecommend
        downloader.getWithUrl(homeRecommendUrl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: 实现UITableView的代理
extension HomePageRecommendView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //滚动广告显示一个分组
        var section = 1
        if model?.data?.returnData?.comicLists?.count > 0 {
            section += (model?.data?.returnData?.comicLists?.count)!
        }
        return section
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //banner广告的section显示一行
        var row = 0
        if section == 0 {
            //广告
            row = 1
        }else{//解析成功后
            let listModel = model?.data?.returnData?.comicLists![section-1]
            if listModel!.itemTitle! == "强力推荐作品" || listModel!.itemTitle! == "条漫每日更新"  || listModel!.itemTitle! == "热门新品"{
                row = 2
            }else if listModel!.itemTitle! == "排行"{
                row = (listModel?.comics?.count)!
            }
            else{
                row = 1
            }
        }
        return row
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = 0
        //gallery高度为140
        if indexPath.section == 0 {
            height = 140
        }else {
            let listModel = model?.data?.returnData?.comicLists![indexPath.section-1]
            if listModel!.itemTitle! == "强力推荐作品" || listModel!.itemTitle! == "人气推荐作品" || listModel!.itemTitle! == "今日更新" || listModel!.itemTitle! == "订阅漫画" || (listModel!.itemTitle! == "热门新品" && indexPath.row == 1) || listModel!.itemTitle! == "VIP会员漫画" {
                height = 180
            }else if listModel!.itemTitle! == "不知道什么鬼" || listModel!.itemTitle! == "每日限免" || listModel!.itemTitle! == "排行" {
                height = 90
            }else if listModel!.itemTitle! == "条漫每日更新" || listModel!.itemTitle! == "完结漫画" {
                height = 140
            }else if (listModel!.itemTitle! == "热门新品" && indexPath.row == 0) {
                height = 120
            }
        }
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            //头部滚动视图
            let cell = HomeGalleryCell.createGalleryCell(tableView, indexPath: indexPath, galleryArray: model?.data?.returnData?.galleryItems)
            cell.jumpClosure = jumpClosure
            return cell
        }else {
            let listModel = model?.data?.returnData?.comicLists![indexPath.section-1]
            if listModel!.itemTitle! == "强力推荐作品" {
                //人气推荐作品，显示2行，特殊处理
                //将数据分割成3个一组
                let range = NSMakeRange(indexPath.row*3, 3)
                let array = NSArray(array: (listModel?.comics)!).subarrayWithRange(range) as! Array<HomeComicData>
                let cell = HomeRecommendCell.createRecommendCellFor(tableView, atIndexPath: indexPath, listModel: array)
                cell.jumpClosure = jumpClosure
                return cell
            }else if listModel!.itemTitle! == "人气推荐作品" || listModel!.itemTitle! == "今日更新" || listModel!.itemTitle! == "订阅漫画" || listModel!.itemTitle! == "VIP会员漫画" {//返回人气推荐作品cell
                let cell = HomeRecommendCell.createRecommendCellFor(tableView, atIndexPath: indexPath, listModel: listModel?.comics)
                cell.jumpClosure = jumpClosure
                return cell
            }else if listModel!.itemTitle! == "不知道什么鬼" {
                let cell = HomeADCell.createHomeADCellFor(tableView, atIndexPath: indexPath, listModel: listModel?.comics)
                cell.jumpClosure = jumpClosure
                return cell
            }else if listModel!.itemTitle! == "条漫每日更新" {
                //人气推荐作品，显示2行，特殊处理
                //将数据分割成2个一组
                let range = NSMakeRange(indexPath.row*2, 2)
                let array = NSArray(array: (listModel?.comics)!).subarrayWithRange(range) as! Array<HomeComicData>
                let cell = HomeUpdateCell.createUpdateCellFor(tableView, atIndexPath: indexPath, listModel: array)
                cell.jumpClosure = jumpClosure
                return cell
            }else if (listModel!.itemTitle! == "热门新品" && indexPath.row == 0) {
                let cell = HomeHotNewCell.createHotNewCellFor(tableView, atIndexPath: indexPath, listModel: listModel?.comics![indexPath.row])
                cell.jumpClosure = jumpClosure
                return cell
            }else if (listModel!.itemTitle! == "热门新品" && indexPath.row == 1) {
                //热门新品有两个不同的cell，需要注意数据的传递
                let range = NSMakeRange(1, 3)
                let array = NSArray(array: (listModel?.comics)!).subarrayWithRange(range) as! Array<HomeComicData>
                let cell = HomeRecommendCell.createRecommendCellFor(tableView, atIndexPath: indexPath, listModel: array)
                cell.jumpClosure = jumpClosure
                return cell
            }else if listModel?.itemTitle! == "每日限免" {
                let cell = HomeLimitCell.createLimitCellFor(tableView, atIndexPath: indexPath, listModel: listModel?.comics)
                cell.jumpClosure = jumpClosure
                return cell
            }else if listModel?.itemTitle! == "完结漫画" {
                let cell = HomeUpdateCell.createUpdateCellFor(tableView, atIndexPath: indexPath, listModel: listModel?.comics)
                cell.jumpClosure = jumpClosure
                return cell
            }else if listModel?.itemTitle! == "排行" {
                let range = NSMakeRange(indexPath.row*1, 1)
                let array = NSArray(array: (listModel?.comics)!).subarrayWithRange(range) as! Array<HomeComicData>
                let cell = HomeRankCell.createRankCellFor(tableView, atIndexPath: indexPath, listModel: array)
                cell.jumpClosure = jumpClosure
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let listModel = self.model?.data?.returnData?.comicLists![section-1]
            if listModel!.itemTitle! == "强力推荐作品" {
                let recommendHeaderView = HomeHeaderView(frame: CGRectMake(0,0,screenWidth,44))
                recommendHeaderView.listModel = listModel
                recommendHeaderView.jumpClosure = jumpClosure
                return recommendHeaderView
            } else if listModel!.itemTitle! == "排行" || listModel!.itemTitle! == "不知道什么鬼"{
                let recommendHeaderView = HomeHeaderView(frame: CGRectMake(0,0,screenWidth,54))
                recommendHeaderView.listModel = listModel
                return recommendHeaderView
            } else {
                let recommendHeaderView = HomeHeaderView(frame: CGRectMake(0,0,screenWidth,54))
                recommendHeaderView.listModel = listModel
                recommendHeaderView.jumpClosure = jumpClosure
                return recommendHeaderView
            }
        }
        return nil
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height:CGFloat = 0
        if section > 0 {
            let listModel = model?.data?.returnData?.comicLists![section-1]
            if listModel!.itemTitle! == "强力推荐作品" {
                //强力推荐作品和gallery直接没有间距
                height = 44
            }else {
                //其他页面都有10间距
                height = 54
            }
        }
        return height
    }
    
    //防止cell点击高亮
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    //去掉UITableView的粘滞性
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let height: CGFloat = 54
        if scrollView.contentOffset.y >= height {
            scrollView.contentInset = UIEdgeInsetsMake(-height, 0, 0, 0)
        }else if scrollView.contentOffset.y > 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
        }
    }
    
}
//MARK: 网址请求代理
extension HomePageRecommendView: U17DownloadDelegate {
    //下载失败
    func downloader(downloader: U17Download, didFailWithError error: NSError) {
        print(error)
    }
    //下载成功
    func downloader(downloader: U17Download, didFinishWithData data: NSData?) {
        if let tmpData = data {
            if downloader.downloadType == HomeDownloadType.HomeRecommend {
                self.tableView!.mj_header.endRefreshing()
                //1.json解析
                let tmpModel = HomeRecommend.parseData(tmpData)
                model = tmpModel
            }
        }else {
            print(data)
        }
    }
}

//刷新页面的代理
extension HomePageRecommendView: CustomAddRefreshProtocol {
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