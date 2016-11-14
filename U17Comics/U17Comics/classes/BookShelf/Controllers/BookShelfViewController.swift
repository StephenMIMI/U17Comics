//
//  BookShelfViewController.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/21.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class BookShelfViewController: BaseViewController, CustomNavigationProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        addTitle("书架")
        view.backgroundColor = customBgColor
        configUI()
    }

    func configUI() {
        let label = UILabel()
        label.text = "该功能暂未实现，先去看看其他的吧!"
        label.textColor = UIColor.lightGrayColor()
        label.numberOfLines = 2
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(15)
        view.addSubview(label)
        
        label.snp_makeConstraints { (make) in
            make.centerX.centerY.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
