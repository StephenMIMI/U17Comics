//
//  HomeComicChapterCell.swift
//  U17Comics
//
//  Created by 张翔宇 on 16/11/5.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeComicChapterCell: UITableViewCell {

    //接受controller
    var controller: UIViewController?
    //目录label
    var catalogLabel: UILabel?
    //更新到某章节label
    var updateLabel: UILabel?
    //排序button
    var sortLabel: UILabel?
    var sortBtn: UIButton?
    var sortBool: Bool? {
        didSet {
            if sortBool == false {
                sortLabel?.text = "正序"
                showData()
            }else {
                sortLabel?.text = "倒序"
                showData()
            }
        }
    }
    //更多章节button
    var moreChapterBtn: UIButton?
    var model: ComicDetailReturnData? {
        didSet {
            if model != nil {
                showData()
            }
        }
    }
    //返回View的动态高度
    class func heightForChapter(num: Int) ->CGFloat {
        var row = num/2
        if num%2 > 0 {
            row += 1
        }
//        if row >= 5 {
//            return CGFloat(5)*(btnH+margin)+30+40
//        }else {
//            return CGFloat(row)*(btnH+margin)+30+40
//        }
        return CGFloat(row)*(btnH+margin)+30+40
    }
    
    
    var lastBtn: UIButton?
    var jumpClosure: HomeJumpClosure?
    var readComicClosure: ReadComicClosure?
    //上下间距
    class private var margin: CGFloat {
        return 8
    }
    class private var btnH: CGFloat {
        return 30
    }
    class private var btnW: CGFloat {
        return (screenWidth-30)/2
    }
    
    func showData() {
        for sub in self.subviews {
            sub.removeFromSuperview()
        }
        configUI()
        if let realCount = model?.chapter_list?.count {
            //先配置基础页面
            
            let chapterList = model?.chapter_list
            if let tmpTime = chapterList![realCount-1].pass_time {
                updateLabel?.text = "\(configDate(tmpTime)) 更新到\(chapterList![realCount-1].name!)"
            }
            var num = 0
            for i in 0..<realCount {
                //只创建10个
                //if i < 10 {
                let btn = UIButton(type: .Custom)
                //倒叙显示
                if sortBool == false {
                    num = realCount-i-1
                }else {
                    num = i
                }
                
                btn.frame = CGRectMake(10+(HomeComicChapterCell.btnW+10)*CGFloat(i%2), 30+(HomeComicChapterCell.btnH+HomeComicChapterCell.margin)*CGFloat(i/2), HomeComicChapterCell.btnW, HomeComicChapterCell.btnH)
                btn.tag = 100+num
                btn.layer.cornerRadius = 5
                btn.layer.masksToBounds = true
                btn.layer.borderWidth = 1
                btn.layer.borderColor = UIColor.grayColor().CGColor
                btn.backgroundColor = UIColor.whiteColor()
                btn.addTarget(self, action: #selector(readComic(_:)), forControlEvents: .TouchUpInside)
                addSubview(btn)
                let btnShowLabel = UILabel(frame: CGRectMake(10,2,btn.bounds.width-20,btn.bounds.height-4))
                
                btnShowLabel.text = chapterList![num].name
                btnShowLabel.textAlignment = .Center
                btnShowLabel.font = UIFont.systemFontOfSize(14)
                btn.addSubview(btnShowLabel)
                //记录最后一个button的位置
                lastBtn = btn
                
                if chapterList![num].type == 3 {
                    //显示VIP Label
                    let vipLabel = UILabel(frame: CGRectMake(0,0,10,12))
                    vipLabel.text = "V"
                    vipLabel.textAlignment = .Right
                    vipLabel.font = UIFont.systemFontOfSize(10)
                    vipLabel.textColor = UIColor.whiteColor()
                    vipLabel.backgroundColor = UIColor.orangeColor()
                    btn.addSubview(vipLabel)
                }
                if chapterList![num].is_new == 1 {
                    //显示new Label
                    let newLabel = UILabel(frame: CGRectMake(HomeComicChapterCell.btnW-10,0,10,12))
                    newLabel.text = "N"
                    newLabel.font = UIFont.systemFontOfSize(10)
                    newLabel.textColor = UIColor.whiteColor()
                    newLabel.backgroundColor = lightGreen
                    btn.addSubview(newLabel)
                }
                //}
            }
            //修改moreBtn的约束
            moreChapterBtn = UIButton(type: .Custom)
            moreChapterBtn?.frame = CGRectMake(screenWidth/2-100, (lastBtn?.frame.origin.y)!+HomeComicChapterCell.btnH+10, 200, 30)
            moreChapterBtn?.addTarget(self, action: #selector(moreChapter), forControlEvents: .TouchUpInside)
            addSubview(moreChapterBtn!)
            let moreChapterLabel = UILabel(frame: (moreChapterBtn?.bounds)!)
            moreChapterLabel.text = "没有更多了"
            moreChapterLabel.textAlignment = .Center
            moreChapterLabel.font = UIFont.systemFontOfSize(14)
            moreChapterBtn?.addSubview(moreChapterLabel)
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

    
    func configUI() {
        
        //设置背景色
        self.backgroundColor = customBgColor
        
        if catalogLabel == nil {
            catalogLabel = UILabel(frame: CGRectMake(10,0,30,30))
            catalogLabel?.text = "目录"
            catalogLabel?.font = UIFont.systemFontOfSize(13)
        }
        addSubview(catalogLabel!)

        if sortBtn == nil {
            sortBtn = UIButton(type: .Custom)
            sortBtn?.frame = CGRectMake(screenWidth-10-30, 0, 30, 30)
            sortBtn?.addTarget(self, action: #selector(sortClick), forControlEvents: .TouchUpInside)
        }
        addSubview(sortBtn!)

        if sortLabel == nil {
            sortLabel = UILabel(frame: CGRectMake(0,0,30,30))
            sortBool = false
            sortLabel?.font = UIFont.systemFontOfSize(13)
        }
        sortBtn!.addSubview(sortLabel!)

        if updateLabel == nil {
            updateLabel = UILabel(frame: CGRectMake(45,5,screenWidth-35-45,20))
            updateLabel?.font = UIFont.systemFontOfSize(12)
            updateLabel?.textColor = UIColor.grayColor()
        }
        addSubview(updateLabel!)

        
    }
    
    //排序按钮点击
    func sortClick(btn: UIButton) {
        sortBool = !(sortBool!)
    }
    
    //阅读某章节
    func readComic(btn: UIButton) {
        let index = btn.tag-100
        if let chapterList = model?.chapter_list {
            if readComicClosure != nil && chapterList[index].chapter_id != nil {
                if chapterList[index].type == 3 {
                    let alter = UIAlertController(title: "提示", message: "VIP章节暂时无法观看", preferredStyle: .Alert)
                    alter.addAction(UIAlertAction(title: "好的吧！", style: .Default, handler: { (a) in
                        print("VIP章节，需要做个弹框提示")
                    }))
                    if controller != nil {
                        controller!.presentViewController(alter, animated: true, completion: nil)
                    }
                }else {
                    let tmpUrl = onlineReadComic+"\(chapterList[index].chapter_id!)"
                    let tmpName = chapterList[index].name
                    let tmpId = chapterList[index].chapter_id
                    readComicClosure!(tmpUrl, tmpName, tmpId)
                }
            }
        }
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
