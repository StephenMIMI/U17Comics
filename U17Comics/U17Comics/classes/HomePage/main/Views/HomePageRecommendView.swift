//
//  HomePageRecommendView.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/25.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

public typealias HomeJumpClosure = (String -> Void)

//定义首页推荐列表的类型
public enum HomeComicType: Int {
    case Comics = 1  //漫画类型section
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        //创建表格视图
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        
        addSubview(tableView!)
        
        tableView?.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self)
        })
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
            if listModel!.itemTitle! == "强力推荐作品" || listModel!.itemTitle! == "条漫每日更新" {
                row = 2
            }else {
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
            if listModel!.itemTitle! == "强力推荐作品" || listModel!.itemTitle! == "人气推荐作品" || listModel!.itemTitle! == "今日更新" || listModel!.itemTitle! == "订阅漫画" {
                height = 180
            }else if listModel!.itemTitle! == "不知道什么鬼" {
                height = 80
            }else if listModel!.itemTitle! == "条漫每日更新" {
                height = 140
            }
        }
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            //头部滚动视图
            let cell = HomeGalleryCell.createGalleryCell(tableView, indexPath: indexPath, galleryArray: model!.data!.returnData!.galleryItems)
            cell.jumpClosure = jumpClosure
            return cell
        }else {
            let listModel = model?.data?.returnData?.comicLists![indexPath.section-1]
            if listModel!.itemTitle! == "强力推荐作品" {
                //人气推荐作品，显示2行，特殊处理
                let comicsModel = model?.data?.returnData?.comicLists![indexPath.section-1].comics
                //将数据分割成3个一组
                var realModel = Array<HomeComicData>()
                for i in indexPath.row*3..<indexPath.row*3+3 {
                    let tmpValue = comicsModel![i]
                    realModel.append(tmpValue)
                }
                let cell = HomeRecommendCell.createRecommendCellFor(tableView, atIndexPath: indexPath, listModel: realModel)
                cell.jumpClosure = jumpClosure
                return cell
            }else if listModel!.itemTitle! == "人气推荐作品" || listModel!.itemTitle! == "今日更新" || listModel!.itemTitle! == "订阅漫画" {//返回人气推荐作品cell
                let cell = HomeRecommendCell.createRecommendCellFor(tableView, atIndexPath: indexPath, listModel: listModel?.comics)
                cell.jumpClosure = jumpClosure
                return cell
            }else if listModel!.itemTitle! == "不知道什么鬼" {
                let cell = HomeADCell.createHomeADCellFor(tableView, atIndexPath: indexPath, listModel: listModel?.comics)
                cell.jumpClosure = jumpClosure
                return cell
            }else if listModel!.itemTitle! == "条漫每日更新" {
                //人气推荐作品，显示2行，特殊处理
                let comicsModel = model?.data?.returnData?.comicLists![indexPath.section-1].comics
                //将数据分割成2个一组
                var realModel = Array<HomeComicData>()
                for i in indexPath.row*2..<indexPath.row*2+2 {
                    let tmpValue = comicsModel![i]
                    realModel.append(tmpValue)
                }
                let cell = HomeUpdateCell.createUpdateCellFor(tableView, atIndexPath: indexPath, listModel: realModel)
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
}
