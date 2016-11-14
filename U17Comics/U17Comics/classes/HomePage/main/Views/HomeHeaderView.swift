//
//  HomeHeaderView.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/27.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {

    //点击事件
    var jumpClosure: HomeJumpClosure?
    
    var listModel: HomeComicList? {
        didSet {
            configHeader(listModel!)
        }
    }
    
    private var bgView: UIView?//白色背景
    private var imageView: UIImageView?//头部视图图片
    private var titleLabel: UILabel?//头部视图标题
    private var moreLabel: UILabel?//头部视图跳转提示文字
    private var moreIcon: UIImageView?
    
    //左右的间距
    private var space: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        bgView = UIView.createView()
        bgView?.backgroundColor = customBgColor
        addSubview(bgView!)
        //添加bgView的约束
        bgView?.snp_makeConstraints(closure: { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        })
        
        imageView = UIImageView()
        imageView?.contentMode = .ScaleAspectFit
        bgView!.addSubview(imageView!)
        imageView!.snp_makeConstraints { (make) in
            make.left.equalTo(bgView!).offset(5)
            make.top.equalTo(bgView!).offset(4)
            make.bottom.equalTo(bgView!).offset(-4)
            make.width.equalTo(35)//头部图片视图大小39x42
        }
        titleLabel = UILabel.createLabel(nil, textAlignment: .Left, font: UIFont.systemFontOfSize(16))
        bgView!.addSubview(titleLabel!)
        
        moreLabel = UILabel.createLabel(nil, textAlignment: .Right, font: UIFont.systemFontOfSize(12))
        bgView!.addSubview(moreLabel!)
        let g = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        bgView!.addGestureRecognizer(g)
    }
    
    func tapAction() {
        //更多跳转参数：argValue=8&argName=topic&argCon=2&page=1
        if jumpClosure != nil {
            if listModel!.argValue != nil && listModel!.argName != nil {
                let tmpUrl = String(format: homeMoreUrl, ((listModel?.argValue)!).intValue, (listModel?.argName)!,2)
                jumpClosure!(tmpUrl,nil,listModel?.itemTitle)
            }else {
                jumpClosure!(homeUnknownMoreUrl,nil,listModel?.itemTitle)
            }
        }
        
    }
    
    private func configHeader(model: HomeComicList) {
        if let tmpurl = model.titleIconUrl {
            let url = NSURL(string: tmpurl)
            imageView?.kf_setImageWithURL(url)
        }
        titleLabel?.text = model.itemTitle
        let str = NSString(string: model.itemTitle!)
        let maxWidth = screenWidth-2*space-100
        let attr = [NSFontAttributeName: UIFont.systemFontOfSize(16)]
        let width = str.boundingRectWithSize(CGSizeMake(maxWidth, 44), options: .UsesLineFragmentOrigin, attributes: attr, context: nil).size.width
        titleLabel?.frame = CGRectMake(50, 0, width, 44)
        if listModel?.itemTitle == "今日限免" || listModel?.itemTitle == "排行" || listModel?.itemTitle == "不知道什么鬼" {
            moreLabel?.text = nil
        }else {
            moreLabel?.text = model.description1
        }
        
        //排行和每日限免的右侧视图不同,init的时候listModel为nil
        if listModel?.itemTitle == "每日限免" {
            moreIcon = UIImageView(image: UIImage(named: "freeLook"))
            moreIcon!.contentMode = .ScaleAspectFill
            moreIcon!.clipsToBounds = true
            bgView!.addSubview(moreIcon!)
            moreIcon!.snp_makeConstraints { (make) in
                make.centerY.equalTo(bgView!)
                make.right.equalTo(bgView!).offset(-10)
                make.width.equalTo(50)
                make.height.equalTo(15)//头部更多icon大小11x21
            }
        }else if listModel?.itemTitle == "排行" || listModel?.itemTitle == "不知道什么鬼"{
            moreIcon?.hidden = true
        }else {
            moreIcon = UIImageView(image: UIImage(named: "recommendview_icon_more_5x10_"))
            moreIcon!.contentMode = .ScaleAspectFill
            moreIcon!.clipsToBounds = true
            bgView!.addSubview(moreIcon!)
            moreIcon!.snp_makeConstraints { (make) in
                make.centerY.equalTo(bgView!)
                make.right.equalTo(bgView!).offset(-10)
                make.width.equalTo(11)
                make.height.equalTo(15)//头部更多icon大小11x21
            }
            
            moreLabel?.snp_makeConstraints(closure: { (make) in
                make.right.equalTo(moreIcon!.snp_left)
                make.top.bottom.equalTo(bgView!)
                make.width.equalTo(50)//给了更多label 50的宽度
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
