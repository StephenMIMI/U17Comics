//
//  HomeVIPCell.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/1.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

enum ViewType: Int {
    case Recommend = 0 //默认为推荐
    case VIP = 1
    case Subscribe = 2
    case RankTicket = 3
    case RankClick = 4
    case RankComment = 5
    case RankNew = 6
    case Collection = 7
    
}

class HomeVIPCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var vipLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!


    //VIP、订阅、排行共用这个cell，定义一个type属性来区分,这里默认为月票页面
    var viewType: ViewType = ViewType.RankTicket
    var indexPath: NSIndexPath?
    
    var jumpClosure: HomeJumpClosure?
    var listModel: HomeVIPComics? {
        didSet {
            showData()
        }
    }
    
    func showData() {
        self.backgroundColor = customBgColor
        rankLabel.hidden = true
        if listModel != nil {
            let model = listModel!
            //设置漫画封面
            if model.cover != nil {
                let url = NSURL(string: (model.cover)!)
                leftImageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "recommend_comic_default_91x115_"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            }
            //设置漫画名字
            if model.name != nil {
                nameLabel.text = model.name
            }
            //漫画tag列表
            var rankStr:String = ""
            if model.tags != nil {
                for i in 0..<(model.tags!.count) {
                    if i == 0 {
                        rankStr = model.tags![i]
                    }else {
                        rankStr += " \(model.tags![i])"
                    }
                }
                tagLabel.text = rankStr
            }
            //漫画描述
            if model.description1 != nil {
                descLabel.text = model.description1
            }
            //付费VIP漫画
            configVIPLabel()
            if viewType == ViewType.VIP {
                updateLabel.hidden = true
            }else if viewType == ViewType.Subscribe {
                if model.conTag != nil {
                    configUpdateLabel(model.conTag!)
                }
            }else if viewType == ViewType.RankTicket {
                if model.conTag != nil {
                    if Int(model.conTag!)! >= 10000 {
                        updateLabel.text = String(format: "月票值 %.02f 万", Double(model.conTag!)!/10000.0)
                    }else {
                        updateLabel.text = "月票值 \(Int(model.conTag!)!)"
                    }
                }
                configRankLabel()
            }else if viewType == ViewType.RankClick {
                if model.conTag != nil {
                    if Int(model.conTag!)! >= 100000000 {
                        updateLabel.text = String(format: "点击值 %.02f 亿", Double(model.conTag!)!/100000000.0)
                    }else if Int(model.conTag!)! >= 10000 {
                        updateLabel.text = String(format: "点击值 %.02f 万", Double(model.conTag!)!/10000.0)
                    }else {
                        updateLabel.text = "点击值 \(Int(model.conTag!)!)"
                    }
                }
                configRankLabel()
            }else if viewType == ViewType.RankComment {
                if model.conTag != nil {
                    if Int(model.conTag!)! >= 100000000 {
                        updateLabel.text = String(format: "吐槽值 %.02f 亿", Double(model.conTag!)!/100000000.0)
                    }else if Int(model.conTag!)! >= 10000 {
                        updateLabel.text = String(format: "吐槽值 %.02f 万", Double(model.conTag!)!/10000.0)
                    }else {
                        updateLabel.text = "吐槽值 \(Int(model.conTag!)!)"
                    }
                }
                configRankLabel()
            }else if viewType == ViewType.RankNew {
                if model.conTag != nil {
                    if Int(model.conTag!)! >= 100000000 {
                        updateLabel.text = String(format: "新作值 %.02f 亿", Double(model.conTag!)!/100000000.0)
                    }else if Int(model.conTag!)! >= 10000 {
                        updateLabel.text = String(format: "新作值 %.02f 万", Double(model.conTag!)!/10000.0)
                    }else {
                        updateLabel.text = "新作值 \(Int(model.conTag!)!)"
                    }
                }
                configRankLabel()
            }else if viewType == ViewType.Collection {
                if model.conTag != nil {
                    if Int(model.conTag!)! >= 100000000 {
                        updateLabel.text = String(format: "总收藏 %.02f 亿", Double(model.conTag!)!/100000000.0)
                    }else if Int(model.conTag!)! >= 10000 {
                        updateLabel.text = String(format: "总收藏 %.02f 万", Double(model.conTag!)!/10000.0)
                    }else {
                        updateLabel.text = "总收藏 \(Int(model.conTag!)!)"
                    }
                }
            }
            let g = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            addGestureRecognizer(g)
        }
    }
    
    func configVIPLabel() {
        //标签颜色和文字
        if let model = listModel {
            if model.flag != nil {
                switch (model.flag?.integerValue)! {
                case 0:
                    vipLabel.hidden = true
                case 1:
                    vipLabel.text = "付费"
                    vipLabel.backgroundColor = UIColor.init(red: 255/255.0, green: 209/255.0, blue: 115/255.0, alpha: 1.0)
                case 2:
                    vipLabel.hidden = true
                case 3:
                    vipLabel.text = "VIP"
                    vipLabel.backgroundColor = UIColor.init(red: 242/255.0, green: 100/255.0, blue: 1/255.0, alpha: 1.0)
                default:
                    break
                }
            }
        }
    }
    
    func tapAction() {
        if listModel?.comicId != nil && jumpClosure != nil {
            let tmpUrl = comicsDetailUrl+"\((listModel?.comicId!)!)"
            let ticketUrl = comicsTicketUrl+"\((listModel?.comicId!)!)"
            jumpClosure!(tmpUrl, ticketUrl, nil)
        }
    }
    
    func configRankLabel() {
        if indexPath?.row < 3 {
            rankLabel.hidden = false
        }
        if indexPath?.row == 0 {
            rankLabel.text = "1"
            rankLabel.backgroundColor = UIColor.redColor()
        }else if indexPath?.row == 1 {
            rankLabel.text = "2"
            rankLabel.backgroundColor = UIColor.orangeColor()
        }else if indexPath?.row == 2 {
            rankLabel.text = "3"
            rankLabel.backgroundColor = lightGreen
        }
    }
    
    //将返回JSON里面的UNIX时间戳转化成时间并计算更新时间
    func configUpdateLabel(date: String) {
        let dateStr = NSString(string: date)
        let timeStamp: NSTimeInterval = dateStr.doubleValue

        let date = NSDate(timeIntervalSince1970: timeStamp)//将UNIX时间戳转化成date格式
        let now = NSDate()//获取当前时间
        let interval: NSTimeInterval = now.timeIntervalSinceDate(date)//计算时间差
        let min = Int(interval/60)
        if min > 0 {
            if min >= 0 && min <= 59 {
                updateLabel.text = "\(min)分钟前更新"
            }else {
                let hour = min/60
                if hour >= 1 && hour <= 23 {
                    updateLabel.text = "\(hour)小时前更新"
                }else {
                    let day = hour/24
                    if day >= 1 && day <= 6 {
                        updateLabel.text = "\(day)天前更新"
                    }else {
                        updateLabel.text = "一周前更新"
                    }
                }
            }
        }else {
            updateLabel.text = "未获取到更新"
        }
        
    }
    
    class func createVIPCellFor(tableView: UITableView, atIndexPath indexPath: NSIndexPath, listModel: HomeVIPComics?, type: ViewType) -> HomeVIPCell {
        let cellId = "homeVIPCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? HomeVIPCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("HomeVIPCell", owner: nil, options: nil).last as? HomeVIPCell
        }
        cell?.viewType = type
        cell?.indexPath = indexPath//赋值得写在前面
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
