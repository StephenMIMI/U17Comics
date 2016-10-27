//
//  HomeHeaderView.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/27.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {

    private var imageView: UIImageView?//头部视图图片
    private var titleLabel: UILabel?//头部视图标题
    private var moreLabel: UILabel?//头部视图跳转提示文字
    
    //左右的间距
    private var space: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        addSubview(imageView!)
        imageView!.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self).offset(1)
            make.bottom.equalTo(self).offset(-1)
            make.width.equalTo(39)//头部图片视图大小39x42
        }
        titleLabel = UILabel.createLabel(nil, textAlignment: .Left, font: UIFont.systemFontOfSize(16))
        addSubview(titleLabel!)
        
        moreLabel = UILabel.createLabel(nil, textAlignment: .Right, font: UIFont.systemFontOfSize(12))
        addSubview(moreLabel!)

        
        let moreIcon = UIImageView(image: UIImage(named: "recommendview_icon_more_5x10_"))
        moreIcon.contentMode = .ScaleAspectFill
        moreIcon.clipsToBounds = true
        addSubview(moreIcon)
        moreIcon.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-10)
            make.width.equalTo(11)
            make.height.equalTo(15)//头部更多icon大小11x21
        }
        
        moreLabel?.snp_makeConstraints(closure: { (make) in
            make.right.equalTo(moreIcon.snp_left)
            make.top.bottom.equalTo(self)
            make.width.equalTo(50)//给了更多label 50的宽度
        })
    }
    
    func configHeader(model: HomeComicList) {
        if let tmpurl = model.newTitleIconUrl {
            let url = NSURL(string: tmpurl)
            imageView?.kf_setImageWithURL(url)
        }else {
            let url = NSURL(string: model.titleIconUrl!)
            imageView?.kf_setImageWithURL(url)
        }
        titleLabel?.text = model.itemTitle
        let str = NSString(string: model.itemTitle!)
        let maxWidth = screenWidth-2*space-100
        let attr = [NSFontAttributeName: UIFont.systemFontOfSize(16)]
        let width = str.boundingRectWithSize(CGSizeMake(maxWidth, 44), options: .UsesLineFragmentOrigin, attributes: attr, context: nil).size.width
        titleLabel?.frame = CGRectMake(50, 0, width, 44)
        
        moreLabel?.text = model.description1

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
