//
//  HomeComicHeaderView.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/4.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeComicHeaderView: UIView {

    private var descLabel: UILabel?
    private var downloadBtn: UIButton?
    private var startReadBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    func configUI() {
        startReadBtn = UIButton()
        startReadBtn?.setTitle("开始阅读", forState: .Normal)
        startReadBtn?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        startReadBtn?.backgroundColor = lightGreen
        startReadBtn?.addTarget(self, action: #selector(startRead), forControlEvents: .TouchUpInside)
        addSubview(startReadBtn!)
        
        startReadBtn?.snp_makeConstraints(closure: { [weak self](make) in
            make.top.equalTo(self!)
            make.right.bottom.equalTo(self!).offset(-5)
            make.width.equalTo(80)
        })
        
        downloadBtn = UIButton()
        downloadBtn?.setTitle("下载", forState: .Normal)
        downloadBtn?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        downloadBtn?.backgroundColor = UIColor.orangeColor()
        downloadBtn?.addTarget(self, action: #selector(startDownload), forControlEvents: .TouchUpInside)
        addSubview(downloadBtn!)
        
        downloadBtn?.snp_makeConstraints(closure: { [weak self](make) in
            make.top.equalTo(self!).offset(5)
            make.bottom.equalTo(self!).offset(-5)
            make.right.equalTo((self!.startReadBtn?.snp_left)!).offset(10)
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
    
    }
    
    func startDownload() {
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
