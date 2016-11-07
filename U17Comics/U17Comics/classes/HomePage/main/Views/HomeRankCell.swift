//
//  HomeRankCell.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/31.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeRankCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightBgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var leftRankLabel: UILabel!//定义一个显示排行的label
    var indexPath: NSIndexPath?
    var jumpClosure: HomeJumpClosure?
    var listModel: Array<HomeComicData>? {
        didSet {
            showData()
        }
    }
    
    func showData() {
        self.backgroundColor = customBgColor
        if listModel!.count > 0 {
            leftRankLabel = UILabel()
            leftRankLabel.backgroundColor = UIColor.lightGrayColor()
            leftRankLabel.textColor = UIColor.whiteColor()
            leftRankLabel.textAlignment = .Center
            leftRankLabel.text = "\((indexPath?.row)!+1)"
            leftRankLabel.layer.cornerRadius = 5
            leftRankLabel.layer.masksToBounds = true
            let model = listModel![0]
            if model.cover != nil {
                let url = NSURL(string: model.cover!)
                leftImageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "recommend_comic_default_91x115_"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                leftImageView.addSubview(leftRankLabel)
                leftRankLabel.snp_makeConstraints(closure: { (make) in
                    make.right.bottom.equalTo(leftImageView)
                    make.width.height.equalTo(30)
                })
            }
            if model.name != nil {
                nameLabel.text = model.name
            }
            var rankStr:String = ""
            if model.tags != nil {
                for i in 0..<model.tags!.count {
                    if i == 0 {
                        rankStr = model.tags![i]
                    }else {
                        rankStr += " \(model.tags![i])"
                    }
                }
                typeLabel.text = rankStr
            }
            if model.author_name != nil {
                authorLabel.text = model.author_name
            }
            let g = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            addGestureRecognizer(g)
            if indexPath?.row == 0 {
                rightBgView.backgroundColor = UIColor.init(red: 212/255.0, green: 255/255.0, blue: 222/255.0, alpha: 1.0)
                leftRankLabel.backgroundColor = UIColor.redColor()
            }else if indexPath?.row == 1 {
                rightBgView.backgroundColor = UIColor.init(red: 255/255.0, green: 228/255.0, blue: 218/255.0, alpha: 1.0)
                leftRankLabel.backgroundColor = UIColor.orangeColor()
            }else if indexPath?.row == 2 {
                rightBgView.backgroundColor = UIColor.init(red: 254/255.0, green: 247/255.0, blue: 220/255.0, alpha: 1.0)
                leftRankLabel.backgroundColor = lightGreen
            }
        }
    }
    
    func tapAction() {
        if listModel!.count > 0 {
            let model = listModel![0]
            if model.comicId != nil && jumpClosure != nil {
                let tmpUrl = comicsDetailUrl+"\(model.comicId!)"
                let tmpTicket = comicsTicketUrl+"\(model.comicId!)"
                jumpClosure!(tmpUrl,tmpTicket,nil)
            }
        }
    }
    
    class func createRankCellFor(tableView: UITableView, atIndexPath indexPath: NSIndexPath, listModel: Array<HomeComicData>?) -> HomeRankCell {
        let cellId = "homeRankCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? HomeRankCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("HomeRankCell", owner: nil, options: nil).last as? HomeRankCell
        }
        cell?.indexPath = indexPath//必须写在前面，否则didSet方法调用的时候 index没有值
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
