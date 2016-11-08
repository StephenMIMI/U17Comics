//
//  HomeComicChapterFooter.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/7.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeComicChapterFooter: UIView {

    private var commentBtn: UIButton?
    private var commentLabel: UILabel?
    var model: ComicDTComment? {
        didSet {
            if model != nil {
                showData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    func showData() {
        if let count = model?.commentCount {
            commentLabel?.text = "评论（\(count)）"
        }
    }
    
    func configUI() {
        self.backgroundColor = UIColor.whiteColor()
        commentBtn = UIButton(type: .Custom)
        commentBtn?.frame = CGRectMake(20, 5, screenWidth-40, 34)
        commentBtn?.layer.cornerRadius = 5
        commentBtn?.layer.masksToBounds = true
        commentBtn?.backgroundColor = lightGreen
        commentBtn?.addTarget(self, action: #selector(btnClick), forControlEvents: .TouchUpInside)
        addSubview(commentBtn!)
        
        commentLabel = UILabel(frame: commentBtn!.bounds)
        commentLabel?.text = ""
        commentLabel?.textColor = UIColor.whiteColor()
        commentLabel?.textAlignment = .Center
        commentLabel?.font = UIFont.systemFontOfSize(14)
        commentBtn?.addSubview(commentLabel!)
    }
    
    func btnClick() {
        print("跳转评论页面")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
