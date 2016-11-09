//
//  ReadComicController.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/9.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import SnapKit

//阅读漫画页面
class ReadComicController: U17TabViewController, CustomNavigationProtocol{

    var scrollView: UIScrollView?
    var containerView: UIView?
    var lastImage: UIImageView?
    var model: ReadComicModel? {
        didSet {
            if model != nil {
                configUI()
            }
        }
    }
    var readComicUrl: String? {
        didSet {
            if readComicUrl != nil {
                downloadData(readComicUrl!)
            }
        }
    }
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //自定义返回按钮
        let backBtn = UIButton(frame: CGRectMake(0,0,30,30))
        backBtn.setImage(UIImage(named: "nav_back_black"), forState: .Normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), forControlEvents: .TouchUpInside)
        addBarButton(backBtn, position: BarButtonPosition.left)
        // Do any additional setup after loading the view.
    }
    
    func backBtnClick() {
        navigationController?.popViewControllerAnimated(true)
    }

    //下载详情的数据
    func downloadData(urlString: String) {
        let downloader = U17Download()
        downloader.delegate = self
        downloader.downloadType = .ComicDetail
        print(urlString)
        downloader.getWithUrl(urlString)
    }
    
    func configUI() {
        if scrollView == nil {
            scrollView = UIScrollView()
            scrollView?.backgroundColor = UIColor.blackColor()
            scrollView?.showsVerticalScrollIndicator = false
            //添加scrollView代理
            scrollView?.delegate = self
            view.addSubview(scrollView!)
            print(view.bounds)
            scrollView?.snp_makeConstraints(closure: { [weak self](make) in
                make.edges.equalTo(self!.view).inset(UIEdgeInsetsMake(0, 10, 0, 10))
            })
            containerView = UIView.createView()
            scrollView?.addSubview(containerView!)
            containerView!.snp_makeConstraints { (make) in
                make.edges.equalTo(scrollView!)
                make.width.equalTo(scrollView!)
            }
        }
        loadComic()
    }
    
    func loadComic() {
        //获取image个数
        if let count = model?.data?.returnData?.image_list?.count {
            print("total= \(count)page")
            //计算图片压缩比例
            var rate:CGFloat = 1.0
            var height:CGFloat = 0
            if currentPage < count {
                //不够3个，有几个加载几个
                var newCount = 3
                if (count-currentPage) < 3 {
                    newCount = (count-currentPage)
                }
                //先加载3个
                for i in currentPage..<currentPage+newCount {
                    let imageData = model?.data?.returnData?.image_list?[i]
                    if let w = NSNumberFormatter().numberFromString((imageData!.width)!) {
                        rate = screenWidth/CGFloat(w)
                    }
                    //转化高度
                    if let h = NSNumberFormatter().numberFromString((imageData!.height)!) {
                        height = CGFloat(h)*rate
                    }
                    let imageView = UIImageView(frame: CGRectMake(0, (height+5)*CGFloat(i), screenWidth-20, height))
                    imageView.kf_indicatorType = .Activity
                    let url = NSURL(string: (imageData?.location)!)
                    imageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "recommend_comic_default_91x115_"), optionsInfo: nil, progressBlock: { (receivedSize, totalSize) in
                        //                    let percentage = (Float(receivedSize)/Float(totalSize))*100.0
                        //                    print("downloading progress: \(percentage)%")
                        }, completionHandler: nil)
                    containerView?.addSubview(imageView)
                    lastImage = imageView
                    currentPage = i+1
                    print(currentPage)
                }
                containerView?.snp_updateConstraints(closure: { (make) in
                    make.bottom.equalTo(lastImage!)
                })
//                containerView?.snp_makeConstraints(closure: { (make) in
//                    make.bottom.equalTo(lastImage!)
//                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: 自定义下载代理
extension ReadComicController: U17DownloadDelegate {
    //下载失败
    func downloader(downloader: U17Download, didFailWithError error: NSError) {
        print(error)
    }
    //下载成功
    func downloader(downloader: U17Download, didFinishWithData data: NSData?) {
        if let tmpData = data {
            model = ReadComicModel.parseData(tmpData)
        }
    }
}

//MARK: scrollView代理
extension ReadComicController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = scrollView.contentOffset.y/(scrollView.bounds.height/2)
        print("index=\(index)")
        if index > 1 {
            //loadComic()
        }
    }
}