//
//  HomeVIPModel.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/1.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeVIPModel: NSObject {
    var code: NSNumber?
    var data: HomeVIPData?
    var msg: String?
    
    class func parseData(data: NSData) -> HomeVIPModel {
        let json = JSON(data: data)
        let model = HomeVIPModel()
        model.code = json["code"].number
        model.data = HomeVIPData.parseModel(json["data"])
        model.msg = json["msg"].string
        return model
    }
}

class HomeVIPData: NSObject {
    var message: String?
    var returnData: HomeVIPReturnData?
    var stateCode: NSNumber?
    
    class func parseModel(json: JSON) -> HomeVIPData {
        let model = HomeVIPData()
        model.message = json["message"].string
        model.returnData = HomeVIPReturnData.parseModel(json["returnData"])
        model.stateCode = json["stateCode"].number
        return model
    }
}

class HomeVIPReturnData: NSObject {
    var comics: Array<HomeVIPComics>?
    var hasMore: NSNumber?
    var page: NSNumber?
    
    class func parseModel(json: JSON) -> HomeVIPReturnData {
        let model = HomeVIPReturnData()
        var comicsArray = Array<HomeVIPComics>()
        for (_,subjson) in json["comics"] {
            comicsArray.append(HomeVIPComics.parseModel(subjson))
        }
        model.comics = comicsArray
        model.hasMore = json["hasMore"].number
        model.page = json["page"].number
        return model
    }
}

class HomeVIPComics: NSObject {
    var author: String?
    var comicId: NSNumber?
    var conTag: String?
    var cover: String?
    var description1: String?
    var flag: NSNumber?
    var name: String?
    var tags: Array<String>?
    
    class func parseModel(json: JSON) -> HomeVIPComics {
        let model = HomeVIPComics()
        model.author = json["author"].string
        model.comicId = json["comicId"].number
        model.conTag = json["conTag"].string
        model.cover = json["cover"].string
        model.description1 = json["description"].string
        model.flag = json["flag"].number
        model.name = json["name"].string
        var tagArray = Array<String>()
        for (_,subjson) in json["tags"] {
            tagArray.append(subjson.string!)
        }
        model.tags = tagArray
        return model
    }
}
