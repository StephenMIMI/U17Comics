//
//  HomeHotNewCell.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/28.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeHotNewCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var jumpClosure: HomeJumpClosure?
    var listModel: HomeComicData? {
        didSet {
            showData()
        }
    }
    
    func showData() {
        self.backgroundColor = customBgColor
        if listModel != nil {
            if listModel!.cover != nil {
                let url = NSURL(string: listModel!.cover!)
                leftImageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "recommend_comic_default_91x115_"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            }
            nameLabel.text = listModel!.name
            authorLabel.text = listModel!.author_name
            descLabel.text = listModel!.short_description
            let g = UIGestureRecognizer(target: self, action: #selector(tapAction))
            addGestureRecognizer(g)
        }
    }
    
    func tapAction() {
        if listModel != nil {
            let imageData = listModel!
            if imageData.comicId != nil && jumpClosure != nil {
                let tmpUrl = comicsDetailUrl+"\(imageData.comicId!)"
                let tmpTicket = comicsTicketUrl+"\(imageData.comicId!)"
                jumpClosure!(tmpUrl,tmpTicket,nil)
            }
        }
    }
    
    class func createHotNewCellFor(tableView: UITableView, atIndexPath indexPath: NSIndexPath, listModel: HomeComicData?) -> HomeHotNewCell {
        let cellId = "homeHotNewCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? HomeHotNewCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("HomeHotNewCell", owner: nil, options: nil).last as? HomeHotNewCell
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
