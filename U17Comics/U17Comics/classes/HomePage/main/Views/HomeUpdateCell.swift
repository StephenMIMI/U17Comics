//
//  HomeUpdateCell.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/28.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeUpdateCell: UITableViewCell {
    
    @IBAction func btnClick(sender: UIButton) {
        let index = sender.tag-400
        let model = listModel![index]
        if jumpClosure != nil && model.comicId != nil {
            let tmpUrl = comicsDetailUrl+"\(model.comicId!)"
            let tmpTicket = comicsTicketUrl+"\(model.comicId)"
            jumpClosure!(tmpUrl,tmpTicket,nil)
        }
    }

    var jumpClosure: HomeJumpClosure?
    
    var listModel: Array<HomeComicData>? {
        didSet {
            showData()
        }
    }
    
    func showData() {
        self.backgroundColor = customBgColor
        let count = listModel?.count
        if count > 0 {
            for i in 0..<2 {
                let model = listModel![i]
                let tmpView = contentView.viewWithTag(100+i)
                if tmpView?.isKindOfClass(UIImageView) == true {
                    let imageView = tmpView as! UIImageView
                    let url = NSURL(string: model.cover!)
                    imageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "recommend_comic_default_91x115_"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)//设置图片
                }
                
                //设置漫画名字
                let tmpView1 = contentView.viewWithTag(200+i)
                if tmpView1?.isKindOfClass(UILabel) == true {
                    let titleLabel = tmpView1 as! UILabel
                    titleLabel.text = model.name
                }
                
                //设置漫画更新集数
                let tmpView2 = contentView.viewWithTag(300+i)
                if tmpView2?.isKindOfClass(UILabel) == true {
                    let descLabel = tmpView2 as! UILabel
                    if model.chapterNew != nil {
                        descLabel.text = "更新至\(model.chapterNew!)话"
                    }else {
                        descLabel.text = "已完结"
                    }
                }
            }
        }
    }
    
    class func createUpdateCellFor(tableView: UITableView, atIndexPath indexPath: NSIndexPath, listModel: Array<HomeComicData>?) -> HomeUpdateCell {
        let cellId = "homeUpdateCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? HomeUpdateCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("HomeUpdateCell", owner: nil, options: nil).last as? HomeUpdateCell
        }
        cell?.listModel = listModel
        return cell!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
