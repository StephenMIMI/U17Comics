//
//  HomePageRecommendView.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/25.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomePageRecommendView: UIView {

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
        tableView?.backgroundColor = UIColor.brownColor()
        
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //gallery高度为140
        return 140
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = HomeGalleryCell.createGalleryCell(tableView, indexPath: indexPath, galleryArray: model!.data!.returnData!.galleryItems)
        return cell
    }
}
