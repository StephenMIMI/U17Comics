//
//  ClassifyCell.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/14.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class ClassifyCell: UITableViewCell {

    var jumpClosure: HomeJumpClosure?
    var listModel: Array<ClassifyRankData>? {
        didSet {
            if listModel != nil {
                showData()
            }
        }
    }
    
    //分类按钮点击
    @IBAction func btnClick(sender: UIButton) {
        let index = sender.tag-100
        if let model = listModel?[index] {
            if jumpClosure != nil && model.argName != nil && model.argValue != nil && model.sortName != nil {
                let tmpUrl = String(format: homeMoreUrl, (model.argValue!).intValue, model.argName!, 2)
                jumpClosure!(tmpUrl, nil, model.sortName)
            }else {
                print("缺少参数！")
            }
        }
    }
    
    
    func showData() {
        let count = listModel?.count
        if count > 0 {
            for i in 0..<3 {
                let model = listModel![i]
                let tmpView = contentView.viewWithTag(200+i)
                //设置封面图片
                if tmpView?.isKindOfClass(UIImageView) == true {
                    let imageView = tmpView as! UIImageView
                    let url = NSURL(string: model.cover!)
                    imageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "recommend_comic_default_91x115_"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                }
                
                //设置title
                let tmpView1 = contentView.viewWithTag(300+i)
                if tmpView1?.isKindOfClass(UILabel) == true {
                    let titleLabel = tmpView1 as! UILabel
                    titleLabel.text = model.sortName!
                }
            }
        }
    }
    
    class func createClassifyCellFor(tableView: UITableView, atIndexPath indexPath: NSIndexPath, listModel: Array<ClassifyRankData>?) -> ClassifyCell {
        let cellId = "classifyCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? ClassifyCell
        if nil == cell {
            cell = NSBundle.mainBundle().loadNibNamed("ClassifyCell", owner: nil, options: nil).last as? ClassifyCell
        }
        cell?.listModel = listModel
        return cell!
    }
    
    override func awakeFromNib() {
        self.backgroundColor = customBgColor
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
