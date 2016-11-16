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
    //发现用cell实现，每次刷新都会复用cell把数据清空，暂时用闭包把值传出去再传进来解决
    var sortValueClosure: (Bool -> Void)?
    var sortBool: Bool? 
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
        //获取行数
        var row = num/2
        if num%2 > 0 {
            row += 1
        }
        return CGFloat(row)*(btnH+margin)+30+40
    }
    var lastBtn: UIButton?
    var jumpClosure: HomeJumpClosure?
    var readComicClosure: ReadComicClosure?
    //上下间距
    class private var margin: CGFloat {
        return 8
    }
    //按钮高度
    class private var btnH: CGFloat {
        return 30
    }
    //按钮宽度
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
                
                let btnShowLabel = createLabel(CGRectMake(10,2,btn.bounds.width-20,btn.bounds.height-4), title: chapterList![num].name, font: UIFont.systemFontOfSize(14))
                btnShowLabel.textAlignment = .Center
                btn.addSubview(btnShowLabel)
                //记录最后一个button的位置
                lastBtn = btn
                
                if chapterList![num].type == 3 {
                    //显示VIP Label
                    let vipLabel = createLabel(CGRectMake(0,0,10,12), title: "V", font: UIFont.systemFontOfSize(10))
                    vipLabel.textAlignment = .Right
                    vipLabel.textColor = UIColor.whiteColor()
                    vipLabel.backgroundColor = UIColor.orangeColor()
                    btn.addSubview(vipLabel)
                }
                if chapterList![num].is_new == 1 {
                    //显示new Label
                    let newLabel = createLabel(CGRectMake(HomeComicChapterCell.btnW-10,0,10,12), title: "N", font: UIFont.systemFontOfSize(10))
                    newLabel.textColor = UIColor.whiteColor()
                    newLabel.backgroundColor = lightGreen
                    btn.addSubview(newLabel)
                }
            }
            //修改moreBtn的约束
            moreChapterBtn = UIButton(type: .Custom)
            moreChapterBtn?.frame = CGRectMake(screenWidth/2-100, (lastBtn?.frame.origin.y)!+HomeComicChapterCell.btnH+10, 200, 30)
            //moreChapterBtn?.addTarget(self, action: #selector(moreChapter), forControlEvents: .TouchUpInside)
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
            catalogLabel = createLabel(CGRectMake(10,0,30,30), title: "目录", font: UIFont.systemFontOfSize(13))
        }
        addSubview(catalogLabel!)

        if sortBtn == nil {
            sortBtn = createBtn(CGRectMake(screenWidth-10-30, 0, 30, 30), title: nil, target: self, action: #selector(sortClick))
        }
        addSubview(sortBtn!)

        if sortLabel == nil {
            sortLabel = createLabel(CGRectMake(0,0,30,30), title: "正序", font: UIFont.systemFontOfSize(13))
            if sortBool == nil {
                sortBool = false
            }
        }
        sortBtn!.addSubview(sortLabel!)

        if updateLabel == nil {
            updateLabel = createLabel(CGRectMake(45,5,screenWidth-35-45,20), title: nil, font: UIFont.systemFontOfSize(12))
            updateLabel?.textColor = UIColor.grayColor()
        }
        addSubview(updateLabel!)

        
    }
    
    //排序按钮点击
    func sortClick() {
        sortBool = !(sortBool!)
        if sortValueClosure != nil {
            sortValueClosure!(sortBool!)
        }
        if sortBool == false {
            sortLabel?.text = "正序"
            showData()
        }else {
            sortLabel?.text = "倒序"
            showData()
        }
    }
    
    //阅读某章节
    func readComic(btn: UIButton) {
        let index = btn.tag-100
        if let chapterList = model?.chapter_list {
            if readComicClosure != nil && chapterList[index].chapter_id != nil {
                if chapterList[index].type == 3 {
                    let alter = UIAlertController(title: "提示", message: "VIP章节暂时无法观看", preferredStyle: .Alert)
                    alter.addAction(UIAlertAction(title: "好的吧！", style: .Default, handler: { (a) in
                        //print("VIP章节，需要做个弹框提示")
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
    
    //自定义创建按钮
    func createLabel(frame: CGRect, title: String?, font: UIFont?) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = title
        if let tmpFont = font {
            label.font = tmpFont
        }
        return label
    }
    
    //自定义创建按钮
    func createBtn(frame: CGRect, title: String?, target: AnyObject?, action: Selector?) -> UIButton {
        let btn = UIButton(type: .Custom)
        btn.frame = frame
        btn.setTitle(title, forState: .Normal)
        if let tmpAction = action {
            btn.addTarget(target, action: tmpAction, forControlEvents: .TouchUpInside)
        }
        return btn
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
