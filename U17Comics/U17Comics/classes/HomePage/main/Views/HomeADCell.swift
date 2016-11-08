//
//  HomeADCell.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/28.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeADCell: UITableViewCell {

    //点击事件
    var jumpClosure: HomeJumpClosure?
    
    var listModel: Array<HomeComicData>? {
        didSet {
            configImage()
        }
    }

    @IBOutlet weak var firstADImage: UIImageView!
    @IBOutlet weak var secondADImage: UIImageView!
    var firstLink: String?
    var secondLink: String?
    
    private func configImage() {
        self.backgroundColor = customBgColor
        if listModel!.count > 0 {
            for i in 0..<2 {
                let tmpModel = listModel![i]
                let url = NSURL(string: tmpModel.cover!)
                if i == 0 {
                    //接受用户点击
                    firstADImage.userInteractionEnabled = true
                    firstADImage.kf_setImageWithURL(url, placeholderImage: UIImage(named: "recommend_comic_default_91x115_"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)//设置图片
                    let g = UITapGestureRecognizer(target: self, action: #selector(firstTapAction))
                    firstADImage.addGestureRecognizer(g)
                }else {
                    //接受用户点击
                    secondADImage.userInteractionEnabled = true
                    secondADImage.kf_setImageWithURL(url, placeholderImage: UIImage(named: "recommend_comic_default_91x115_"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)//设置图片
                    let g = UITapGestureRecognizer(target: self, action: #selector(secondTapAction))
                    secondADImage.addGestureRecognizer(g)
                }
                for j in 0..<listModel![i].ext!.count {
                    let tpModel = listModel![i].ext![j]
                    if tpModel.key == "url" {
                        if i == 0 {
                            firstLink = tpModel.val!
                        }else {
                            secondLink = tpModel.val!
                        }
                        
                    }
                }
                
            }
        }
    }
    
    func firstTapAction() {
        if jumpClosure != nil && firstLink != nil {
            var title = ""
            if listModel?[0].ext?[1].val != nil {
                title = (listModel?[0].ext?[1].val)!
            }
            jumpClosure!(firstLink!,nil,title)
        }
    }
    
    func secondTapAction() {
        if jumpClosure != nil && secondLink != nil {
            var title = ""
            if listModel?[1].ext?[1].val != nil {
                title = (listModel?[1].ext?[1].val)!
            }
            jumpClosure!(secondLink!,nil,title)
        }
    }
    
    class func createHomeADCellFor(tableView: UITableView, atIndexPath indexPath: NSIndexPath, listModel: Array<HomeComicData>?) -> HomeADCell {
        let cellId = "homeADCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? HomeADCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("HomeADCell", owner: nil, options: nil).last as? HomeADCell
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
