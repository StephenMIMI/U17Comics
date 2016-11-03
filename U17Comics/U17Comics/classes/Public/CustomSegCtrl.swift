//
//  CustomSegCtrl.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/1.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

protocol CustomSegCtrlDelegate:NSObjectProtocol {
    //点击事件
    func segmentCtrl(segCtrl: CustomSegCtrl, didClickBtnAtIndex index: Int)
}

class CustomSegCtrl: UIView {

    //下划线视图
    private var lineView: UIView?
    //设置代理
    weak var delegate: CustomSegCtrlDelegate?
    //设置当前序号
    var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex != oldValue {
                //取消之前的选中，并允许点击
                let lastBtn = viewWithTag(300+oldValue)
                if lastBtn?.isKindOfClass(CustomSegmentBtn) == true {
                    let tmpBtn = lastBtn as! CustomSegmentBtn
                    tmpBtn.clicked = false
                }
                //选中当前点击按钮，并不许继续点击
                let curBtn = viewWithTag(300+selectedIndex)
                if curBtn?.isKindOfClass(CustomSegmentBtn) == true {
                    let tmpBtn = curBtn as! CustomSegmentBtn
                    tmpBtn.clicked = true
                }
                
                UIView.animateWithDuration(0.25, animations: { [unowned self] in
                    self.lineView?.frame.origin.x = (self.lineView?.frame.width)!*CGFloat(self.selectedIndex)
                })
            }
        }
    }
    
    init(frame: CGRect, titleArray: Array<String>?) {
        super.init(frame: frame)
        if let tmpArray = titleArray {
            if tmpArray.count > 0 {
                createBtns(tmpArray)
            }
        }
    }
    
    func createBtns(titleArray: Array<String>) {
        let width = bounds.size.width/CGFloat(titleArray.count)
        for i in 0..<titleArray.count {
            //循环创建按钮
            let frame = CGRectMake(CGFloat(i)*width, 0, width, bounds.size.height)
            let btn = CustomSegmentBtn(frame: frame)
            if i == 0 {
                btn.clicked = true
            }else {
                btn.clicked = false
            }
            btn.configTitle(titleArray[i])
            addSubview(btn)
            //添加点击事件
            btn.tag = 300+i
            btn.addTarget(self, action: #selector(btnClick(_:)), forControlEvents: .TouchUpInside)
        }
        //下划线视图
        lineView = UIView(frame: CGRectMake(0, bounds.size.height-2, width, 2))
        lineView?.backgroundColor = lightGreen
        addSubview(lineView!)
    }
    
    func btnClick(btn: CustomSegmentBtn) {
        let index = btn.tag-300
        //修改selectedIndex的值
        selectedIndex = index
        delegate?.segmentCtrl(self, didClickBtnAtIndex: selectedIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomSegmentBtn: UIControl {
    private var titleLabel: UILabel?
    //设置选中状态
    var clicked: Bool = false {
        didSet {
            if clicked == true {
                titleLabel?.textColor = lightGreen
            }else {
                titleLabel?.textColor = UIColor.blackColor()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel.createLabel(nil, textAlignment: .Center, font: UIFont.systemFontOfSize(18))
        titleLabel?.frame = bounds
        addSubview(titleLabel!)
    }
    
    func configTitle(title: String) {
        titleLabel?.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
