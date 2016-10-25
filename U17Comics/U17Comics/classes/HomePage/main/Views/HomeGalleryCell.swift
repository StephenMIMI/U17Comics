//
//  HomeGalleryCell.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/25.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeGalleryCell: UITableViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
//    private var imageArray: Array<String>?
//    private var preImageView:UIImageView?
//    private var nextImageView:UIImageView?
//    private var currentImageView:UIImageView?
    //接受数据
    var GalleryArray: Array<HomeGalleryItem>? {
        didSet {
            showData()
        }
    }
    
    class func createGalleryCell(tableView: UITableView, indexPath: NSIndexPath, galleryArray: Array<HomeGalleryItem>?) -> HomeGalleryCell {
        let cellId = "homeGalleryCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? HomeGalleryCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("HomeGalleryCell", owner: nil, options: nil).last as? HomeGalleryCell
        }
        
        //传值
        cell?.GalleryArray = galleryArray
        return cell!
    }
    
    private func showData() {
        let count = GalleryArray?.count//获取scrollView Image数量
//        var tempImageArray = Array<String>()
        if count > 0 {
            //滚动视图添加约束
            //1.创建一个容器视图
            let containerView = UIView.createView()
            scrollView.delegate = self
            scrollView.addSubview(containerView)
            containerView.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(scrollView)
                //横向滚动需约束高度，避免可以上下滚动
                make.height.equalTo(scrollView)
            })
            
            var lastView: UIView? = nil
            for i in 0..<count! {
                let model = GalleryArray![i]
//                tempImageArray.append(model.cover!)
                //创建图片
                let tmpImageView = UIImageView()
                let url = NSURL(string: model.cover!)
                tmpImageView.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                containerView.addSubview(tmpImageView)
                //图片的约束
                tmpImageView.snp_makeConstraints(closure: { (make) in
                    make.top.bottom.equalTo(containerView)
                    make.width.equalTo(scrollView)
                    if lastView == nil {
                        make.left.equalTo(containerView)
                    }else {
                        make.left.equalTo((lastView?.snp_right)!)
                    }
                })
                lastView = tmpImageView
            }
            //修改container的宽度
            containerView.snp_makeConstraints(closure: { (make) in
                make.right.equalTo(lastView!)
            })
            pageControl.numberOfPages = count!
        }
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
//MARK: UIScrollView的代理
extension HomeGalleryCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x/scrollView.bounds.width
        pageControl.currentPage = Int(index)
    }
}