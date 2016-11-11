//
//  HomeComicHeaderView.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/4.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeComicHeaderView: UIView {

    //接受controller
    var controller: UIViewController?
    var readComicClosure: ReadComicClosure?
    //接受已阅读章节的名字
    var chapterName: String?
    var chapterId: String? {
        didSet {
            updateUI()
        }
    }
    private var descLabel: UILabel?
    private var downloadBtn: UIButton?
    private var startReadBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    func updateUI() {
        if chapterName != nil {
            descLabel?.text = "上次看到 \(chapterName!)"
            startReadBtn?.setTitle("继续阅读", forState: .Normal)
        }
    }
    
    func configUI() {
        startReadBtn = UIButton(type: .Custom)
        startReadBtn?.setTitle("开始阅读", forState: .Normal)
        startReadBtn?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        startReadBtn?.backgroundColor = lightGreen
        startReadBtn?.addTarget(self, action: #selector(startRead), forControlEvents: .TouchUpInside)
        startReadBtn?.layer.cornerRadius = 5
        startReadBtn?.layer.masksToBounds = true
        addSubview(startReadBtn!)
        
        startReadBtn?.snp_makeConstraints(closure: { [weak self](make) in
            make.top.equalTo(self!).offset(5)
            make.right.bottom.equalTo(self!).offset(-5)
            make.width.equalTo(80)
        })
        
        downloadBtn = UIButton(type: .Custom)
        downloadBtn?.setTitle("下载", forState: .Normal)
        downloadBtn?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        downloadBtn?.backgroundColor = UIColor.orangeColor()
        downloadBtn?.addTarget(self, action: #selector(startDownload), forControlEvents: .TouchUpInside)
        downloadBtn?.layer.cornerRadius = 5
        downloadBtn?.layer.masksToBounds = true
        addSubview(downloadBtn!)
        
        downloadBtn?.snp_makeConstraints(closure: { [weak self](make) in
            make.top.equalTo(self!).offset(5)
            make.bottom.equalTo(self!).offset(-5)
            make.right.equalTo((self!.startReadBtn?.snp_left)!).offset(-10)
            make.width.equalTo(80)
            
        })
        
        descLabel = UILabel()
        descLabel?.font = UIFont.systemFontOfSize(12)
        descLabel?.text = "暂未阅读"
        descLabel?.textColor = UIColor.grayColor()
        
        addSubview(descLabel!)
        descLabel?.snp_makeConstraints(closure: { [weak self](make) in
            make.left.equalTo(5)
            make.top.equalTo(self!).offset(10)
            make.height.equalTo(20)
            make.right.equalTo((self!.downloadBtn?.snp_left)!).offset(20)
        })
    }
    
    func startRead() {
        if chapterId != nil {
            let tmpUrl = onlineReadComic+"\(chapterId!)"
            readComicClosure!(tmpUrl, chapterName, chapterId)
        }
    }
    
    func startDownload() {
        let alter = UIAlertController(title: "提示", message: "下载暂未实现~SORRY", preferredStyle: .Alert)
        alter.addAction(UIAlertAction(title: "好的吧！", style: .Default, handler: { (a) in
            //占位
        }))
        if controller != nil {
            controller!.presentViewController(alter, animated: true, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
