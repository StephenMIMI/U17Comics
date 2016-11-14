//
//  U17Download.swift
//  U17Comics
//
//  Created by qianfeng on 16/10/24.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import Alamofire

protocol U17DownloadDelegate: NSObjectProtocol {
    //下载失败
    func downloader(downloader: U17Download, didFailWithError error: NSError)
    //下载成功
    func downloader(downloader: U17Download, didFinishWithData data: NSData?)
}

enum HomeDownloadType: Int {
    case RankTicket     //排行月票
    case RankClick      //排行点击
    case RankComment    //排行评论
    case RankNew        //排行新作
    case HomeRecommend  //首页推荐
    case HomeVIP        //首页VIP
    case HomeSubscribe //首页分类
    case HomeRank       //首页排行
    case MoreComic   //漫画更多
    case ComicDetail    //漫画详情
    case ComicTicket    //漫画月票信息
    case Normal
    case Classify      //分类
}


class U17Download: NSObject {
    weak var delegate: U17DownloadDelegate?
    
    //下载的类型
    var downloadType: HomeDownloadType = HomeDownloadType.Normal
    
    //GET请求
    func getWithUrl(urlString: String) {
        Alamofire.request(.GET, urlString).responseData { (response) in
            switch response.result {
            case .Failure(let error):
                //下载失败
                self.delegate?.downloader(self, didFailWithError: error)
            case .Success:
                //下载成功
                self.delegate?.downloader(self, didFinishWithData: response.data)
            }
        }
    }
}
