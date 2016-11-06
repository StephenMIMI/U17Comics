//
//  HomeComicChapterCell.swift
//  U17Comics
//
//  Created by 张翔宇 on 16/11/5.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeComicChapterCell: UITableViewCell {

    
    //目录label
    var catalogLabel: UILabel?
    //更新到某章节label
    var updateLabel: UILabel?
    //排序button
    var sortBtn: UIButton?
    //更多章节button
    var moreChapterBtn: UIButton?
    var model: ComicDetailReturnData? {
        didSet {
            if model != nil {
                configUI()
                showData()
            }
        }
    }
    //返回View的动态高度
    //    class var viewHeight: CGFloat {
    //
    //    }
    
    
    var lastBtn: UIButton?
    var jumpClosure: HomeJumpClosure?
    private var margin: CGFloat = 5
    private var btnH: CGFloat = 30
    private var btnW: CGFloat = (screenWidth-30)/2
    
    func showData() {
        if let realCount = model?.chapter_list?.count {
            let chapterList = model?.chapter_list
            if let tmpTime = chapterList![realCount-1].pass_time {
                updateLabel?.text = "\(configDate(tmpTime)) 更新到\(chapterList![realCount-1].name)"
            }
            for i in 0..<realCount {
                //只创建10个
                if i < 10 {
                    let btn = UIButton(type: .Custom)
                    //倒叙显示
                    let num = realCount-i-1
                    btn.frame = CGRectMake(10+(btnW+10)*CGFloat(i%2), 30+(btnH+margin)*CGFloat(i/2), btnW, btnH)
                    btn.setTitle(chapterList![num].name, forState: .Normal)
                    btn.tag = 100+(num)
                    btn.layer.cornerRadius = 5
                    btn.layer.masksToBounds = true
                    btn.addTarget(self, action: #selector(readComic(_:)), forControlEvents: .TouchUpInside)
                    addSubview(btn)
                    //记录最后一个button的位置
                    lastBtn = btn
                    
                    if chapterList![num].type == 3 {
                        //显示VIP Label
                        let vipLabel = UILabel(frame: CGRectMake(0,0,10,10))
                        vipLabel.text = "VIP"
                        vipLabel.textColor = UIColor.whiteColor()
                        vipLabel.backgroundColor = UIColor.orangeColor()
                        btn.addSubview(vipLabel)
                    }
                    if chapterList![num].is_new == 1 {
                        //显示new Label
                        let newLabel = UILabel(frame: CGRectMake(btnW-10,0,10,10))
                        newLabel.text = "new"
                        newLabel.textColor = UIColor.whiteColor()
                        newLabel.backgroundColor = lightGreen
                        btn.addSubview(newLabel)
                    }
                }
            }
            //修改moreBtn的约束
            moreChapterBtn?.snp_makeConstraints(closure: { [weak self](make) in
                make.centerX.equalTo(self!)
                make.top.equalTo((self!.lastBtn?.snp_bottom)!).offset(5)
                make.width.equalTo(200)
                make.height.equalTo(30)
                })
        }
    }
    
    func configDate(date: NSNumber) -> String {
        let timeStamp: NSTimeInterval = date.doubleValue
        
        let date = NSDate(timeIntervalSince1970: timeStamp)//将UNIX时间戳转化成date格式
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.stringFromDate(date)
        return dateStr
    }
    
    func readComic(btn: UIButton) {
        let index = btn.tag-100
        if let chapterList = model?.chapter_list {
            if jumpClosure != nil && chapterList[index].chapter_id != nil {
                jumpClosure!(chapterList[index].chapter_id!,nil)
            }
        }
        
    }
    
    func configUI() {
        catalogLabel = UILabel()
        catalogLabel?.text = "目录"
        catalogLabel?.font = UIFont.systemFontOfSize(13)
        addSubview(catalogLabel!)
        
        catalogLabel?.snp_makeConstraints(closure: { [weak self](make) in
            make.left.equalTo(self!).offset(10)
            make.top.equalTo(self!).offset(5)
            make.width.height.equalTo(20)
            })
        
        sortBtn = UIButton(type: .Custom)
        sortBtn?.setTitle("正序", forState: .Normal)
        addSubview(sortBtn!)
        
        sortBtn?.snp_makeConstraints(closure: { [weak self](make) in
            make.top.equalTo(self!).offset(5)
            make.right.equalTo(self!).offset(-10)
            make.width.height.equalTo(20)
            })
        
        
        updateLabel = UILabel()
        updateLabel?.font = UIFont.systemFontOfSize(12)
        updateLabel?.textColor = UIColor.grayColor()
        addSubview(updateLabel!)
        
        updateLabel?.snp_makeConstraints(closure: { [weak self](make) in
            make.left.equalTo((self!.catalogLabel?.snp_right)!).offset(5)
            make.top.equalTo(self!).offset(5)
            make.height.equalTo(20)
            make.right.greaterThanOrEqualTo((self!.sortBtn?.snp_left)!).offset(10)
            })
        
        moreChapterBtn = UIButton(type: .Custom)
        moreChapterBtn?.setTitle("更多章节点击查看", forState: .Normal)
        moreChapterBtn?.addTarget(self, action: #selector(moreChapter), forControlEvents: .TouchUpInside)
        addSubview(moreChapterBtn!)
        
        moreChapterBtn?.snp_makeConstraints(closure: { [weak self](make) in
            make.centerX.equalTo(self!)
            make.top.equalTo(self!).offset(35)
            make.width.equalTo(200)
            make.height.equalTo(30)
            })
    }
    
    func moreChapter() {
        
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
