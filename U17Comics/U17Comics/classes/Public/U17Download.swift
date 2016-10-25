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

class U17Download: NSObject {
    weak var delegate: U17DownloadDelegate?
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
