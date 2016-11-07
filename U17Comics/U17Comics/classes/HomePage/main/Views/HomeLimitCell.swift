//
//  HomeLimitCell.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/31.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeLimitCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var jumpClosure: HomeJumpClosure?
    var listModel: Array<HomeComicData>? {
        didSet {
            showData()
        }
    }
    
    func showData() {
        self.backgroundColor = customBgColor
        if listModel?.count > 0 {
            let imageData = listModel![0]
            if imageData.cover != nil {
                let url = NSURL(string: imageData.cover!)
                leftImageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "recommend_comic_default_91x115_"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            }
            nameLabel.text = imageData.name
            authorLabel.text = imageData.author_name
        }
        let g = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(g)
    }
    
    func tapAction() {
        if listModel?.count > 0 {
            let imageData = listModel![0]
            if imageData.comicId != nil && jumpClosure != nil {
                let tmpUrl = comicsDetailUrl+"\(imageData.comicId!)"
                let tmpTicket = comicsTicketUrl+"\(imageData.comicId!)"
                jumpClosure!(tmpUrl,tmpTicket,nil)
            }
        }
    }
    
    class func createLimitCellFor(tableView: UITableView, atIndexPath indexPath: NSIndexPath, listModel: Array<HomeComicData>?) -> HomeLimitCell {
        let cellId = "homeLimitCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? HomeLimitCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("HomeLimitCell", owner: nil, options: nil).last as? HomeLimitCell
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
