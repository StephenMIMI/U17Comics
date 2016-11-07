//
//  HomeComicHeaderCell.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/4.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeComicHeaderCell: UITableViewCell {

    //收藏按钮
    @IBAction func collectionClick(sender: UIButton) {
    }
    //分享按钮
    @IBAction func shareClick(sender: UIButton) {
    }
    //月票按钮
    @IBAction func ticketBtnClick(sender: UIButton) {
    }
    //返回按钮
    @IBAction func backBtnClick() {
        if backClosure != nil {
            backClosure!()
        }
    }
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var ticketBtn: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var VIPLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var clickCountLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var ticketLabel: UILabel!
    
    var backClosure: (Void -> Void)?
    var jumpClosure: HomeJumpClosure?
    //月票数据
    var ticketModel: ComicDTReturnData?
    var model: ComicDetailReturnData? {
        didSet {
            if model != nil {
                showData()
            }
        }
    }
    
    func showData() {
        if let comicModel = model?.comic {
            if let tmpCover = comicModel.cover {
                let url = NSURL(string: tmpCover)
                bgImageView.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
                coverImageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "recommend_comic_default_91x115_"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                coverImageView.layer.borderColor = UIColor.whiteColor().CGColor
                coverImageView.layer.borderWidth = 2
                coverImageView.layer.cornerRadius = 2
                coverImageView.layer.masksToBounds = true
            }
            //VIP label默认隐藏
            VIPLabel.hidden = true
            if let isvip = comicModel.is_vip {
                if isvip == 3 {
                    VIPLabel.hidden = false
                }
            }
            nameLabel.adjustsFontSizeToFitWidth = true
            nameLabel.text = comicModel.name
            authorLabel.text = comicModel.author?.name
            if let tmpTotalClick = ticketModel?.comic?.total_click?.integerValue {
                if tmpTotalClick >= 0 && tmpTotalClick <= 9999 {
                    clickCountLabel.text = "\(tmpTotalClick)"
                }else if tmpTotalClick >= 10000 && tmpTotalClick <= 99999999 {
                    clickCountLabel.text = String(format: "%.2f万", Double(tmpTotalClick)/10000.0)
                }else if tmpTotalClick > 100000000 {
                    clickCountLabel.text = String(format: "%.2f亿", Double(tmpTotalClick)/100000000.0)
                }else {
                    //获取点击参数错误
                    clickCountLabel.text = "没拿到数据呢"
                }
            }
            
            //类型按钮赋值
            var typeStr = ""
            for i in 0..<comicModel.theme_ids!.count {
                if i == 0 {
                    typeStr = comicModel.theme_ids![i]
                }else {
                    typeStr += " \(comicModel.theme_ids![i])"
                }
            }
            typeLabel.text = typeStr
            descLabel.text = comicModel.description1
            descLabel.userInteractionEnabled = true
            //详情label可以跳转作者详情页面
            let g = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            descLabel.addGestureRecognizer(g)
            if let tmpTicket = ticketModel?.comic?.monthly_ticket?.integerValue {
                if tmpTicket >= 0 && tmpTicket <= 99999 {
                    ticketLabel.text = "\(tmpTicket)"
                }else if tmpTicket >= 100000 {
                    ticketLabel.text = String(format: "%.2f万", Double(tmpTicket)/100000.0)
                }
            }
            
            //画一个圆角按钮
            ticketBtn.layer.cornerRadius = 25
            ticketBtn.layer.masksToBounds = true
        }
    }
    
    func tapAction() {
        if let comicModel = model?.comic {
            if jumpClosure != nil && comicModel.author?.id != nil {
                jumpClosure!((comicModel.author?.id)!,nil,nil)
            }
        }
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
