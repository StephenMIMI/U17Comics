//
//  ReadComicCell.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/10.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class ReadComicCell: UITableViewCell {

    @IBOutlet weak var comicImage: UIImageView!
    var urlString: String? {
        didSet {
            if urlString != nil {
                showImage()
            }
        }
    }
    
    func showImage() {
        comicImage.kf_indicatorType = .Activity
        let url = NSURL(string: urlString!)
        comicImage.kf_setImageWithURL(url, placeholderImage: UIImage(named: "recommend_comic_default_91x115_"), optionsInfo: nil, progressBlock: { (receivedSize, totalSize) in
            //                    let percentage = (Float(receivedSize)/Float(totalSize))*100.0
            //                    print("downloading progress: \(percentage)%")
            }, completionHandler: nil)
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
