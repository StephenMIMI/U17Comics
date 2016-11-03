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
    case Normal = 0
    case HomeRecommend  //首页推荐
    case HomeVIP        //首页VIP
    case HomeSubscribe //首页分类
    case HomeRank       //首页排行
    case RankTicket
    case RankClick
    case RankComment
    case RankNew
    case MoreComic   //漫画更多
    case ComicDetail
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
