//
//  MainTabBarController.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/21.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    private var bgView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createViewControllers()
        createMyTabBar()
    }

    
    func createViewControllers() {
        let nameArray = ["HomePageViewController","SearchViewController","BookShelfViewController","ProfileViewController"]
        var ctrlArray = Array<UINavigationController>()
        for i in 0..<nameArray.count {
            let name = "U17Comics."+nameArray[i]
            let ctrl = NSClassFromString(name) as! UIViewController.Type
            let vc = ctrl.init()
            let navCtrl = UINavigationController(rootViewController: vc)
            ctrlArray.append(navCtrl)
        }
        viewControllers = ctrlArray
    }
    
    func createMyTabBar() {
        bgView = UIView.createView()
        bgView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        view.addSubview(bgView!)
    }
    
    func btnClick(btn: UIButton) {
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
