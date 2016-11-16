//
//  HomeGalleryCell.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/25.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class HomeGalleryCell: UITableViewCell {

    var jumpClosure: HomeJumpClosure?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var viewWidth:CGFloat{//获取scrollView自己的高宽
        return self.frame.size.width
    }
    var viewHeight:CGFloat{
        return self.frame.size.height
    }
    private var imageArray: Array<String>?
    private var preImageView:UIImageView?
    private var nextImageView:UIImageView?
    private var currentImageView:UIImageView?
    private var timer:NSTimer!
    private var currentPage:Int = 0
    //接受数据
    var GalleryArray: Array<HomeGalleryItem>? {
        didSet {
            if let count = GalleryArray?.count {
                var tmpArray = Array<String>()
                for i in 0..<count {
                    if GalleryArray![i].cover != nil {
                         tmpArray.append(GalleryArray![i].cover!)
                    }
                }
                imageArray = tmpArray
                showData()
            }
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
        //注意:滚动视图系统默认添加了一些子视图,删除子视图时要考虑一下会不会影响这些子视图
        
        //删除滚动视图之前的子视图
        for sub in scrollView.subviews {
            sub.removeFromSuperview()
        }
        if let count = imageArray?.count {
            if count > 1 {
 
                //定义好轮播的3个视图
                let g = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
                preImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
                //preImageView?.userInteractionEnabled = true
                //preImageView!.addGestureRecognizer(g)
                scrollView.addSubview(preImageView!)
                //添加手势
                currentImageView = UIImageView(frame: CGRect(x: viewWidth, y: 0, width: viewWidth, height: viewHeight))
                currentImageView?.userInteractionEnabled = true
                currentImageView!.addGestureRecognizer(g)
                scrollView.addSubview(currentImageView!)
                
                nextImageView = UIImageView(frame: CGRect(x: 2*viewWidth, y: 0, width: viewWidth, height: viewHeight))
                //nextImageView?.userInteractionEnabled = true
                //nextImageView!.addGestureRecognizer(g)
                scrollView.addSubview(nextImageView!)
                
                scrollView.contentSize = CGSize(width: 3*viewWidth, height: viewHeight)
                scrollView.contentOffset = CGPoint(x: viewWidth, y: 0)
                scrollView.delegate = self

                pageControl.numberOfPages = count
                //添加定时器
                timer=NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(timeRun), userInfo: nil, repeats: false)
                
                preImageView!.kf_setImageWithURL(NSURL(string: imageArray![count-1]), placeholderImage: UIImage(named: "recommend_comic_default_91x115_"))
                currentImageView!.kf_setImageWithURL(NSURL(string: imageArray![0]), placeholderImage: UIImage(named: "recommend_comic_default_91x115_"))
                nextImageView!.kf_setImageWithURL(NSURL(string: imageArray![1]), placeholderImage: UIImage(named: "recommend_comic_default_91x115_"))
                pageControl.currentPage = currentPage
            }
        }
    }
    
    func timeRun(){
        UIView.animateWithDuration(0.3, animations: { [unowned self] in
            self.scrollView.contentOffset=CGPointMake(self.viewWidth*2, 0)
        }) { [unowned self](b) in
            self.scrollViewDidEndDecelerating(self.scrollView)
        }
    }
    
    func tapImage(g: UIGestureRecognizer) {
        //获取点击的数据
        let gallery = GalleryArray![currentPage].ext
        
        if jumpClosure != nil  && gallery![0].val != nil {
            if (gallery![0].val!).hasPrefix("http://") {
                if gallery?.count > 1 {
                    jumpClosure!(gallery![0].val!, nil,gallery![1].val)
                }else {
                    jumpClosure!(gallery![0].val!, nil, nil)
                }
            }else {
                let tmpUrl = "\(comicsDetailUrl)+\(gallery![0].val!)"
                let tmpTicket = "\(comicsTicketUrl)+\(gallery![0].val!)"
                jumpClosure!(tmpUrl,tmpTicket,nil)
            }
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
        timer.invalidate()
        timer=NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(timeRun), userInfo: nil, repeats: false)
        if scrollView.contentOffset.x == 2*viewWidth{
            //手从右往左滑动
            currentPage = (currentPage+1) % imageArray!.count
        }else if scrollView.contentOffset.x == 0{
            //从左往右滑动
            currentPage = (currentPage-1+imageArray!.count) % imageArray!.count
        }
        currentImageView!.kf_setImageWithURL(NSURL(string: imageArray![currentPage]), placeholderImage: UIImage(named: "recommend_comic_default_91x115_"))
        nextImageView!.kf_setImageWithURL(NSURL(string: imageArray![(currentPage+1)%imageArray!.count]), placeholderImage: UIImage(named: "recommend_comic_default_91x115_"))
        preImageView!.kf_setImageWithURL(NSURL(string: imageArray![(currentPage-1+imageArray!.count)%imageArray!.count]), placeholderImage: UIImage(named: "recommend_comic_default_91x115_"))
        pageControl.currentPage = currentPage
        scrollView.contentOffset = CGPoint(x: viewWidth, y: 0)
    }
}