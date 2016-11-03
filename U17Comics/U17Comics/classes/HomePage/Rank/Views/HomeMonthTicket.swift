//
//  HomeMonthTicket.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeMonthTicket: UIView {

    private var tableView: UITableView?
    var viewType: ViewType = ViewType.RankTicket
    var jumpClosure: HomeJumpClosure?
    var model: HomeVIPModel? {
        didSet {
            tableView?.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        addSubview(tableView!)
        
        tableView?.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeMonthTicket: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tmpModel = model?.data?.returnData?.comics
        if tmpModel?.count > 0 {
            return (tmpModel?.count)!
        }else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let listModel = model?.data?.returnData?.comics![indexPath.row]
        let cell = HomeVIPCell.createVIPCellFor(tableView, atIndexPath: indexPath, listModel: listModel, type: viewType)
        cell.jumpClosure = jumpClosure
        return cell
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}
