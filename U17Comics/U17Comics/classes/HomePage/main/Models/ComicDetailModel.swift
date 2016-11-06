//
//  ComicDetailModel.swift
//  U17Comics
//
//  Created by qianfeng on 16/11/3.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import SwiftyJSON

class ComicDetailModel: NSObject {
    var code: NSNumber?
    var data: ComicDetailData?
    
    class func parseData(data: NSData) -> ComicDetailModel {
        let json = JSON(data: data)
        let model = ComicDetailModel()
        model.code = json["json"].number
        model.data = ComicDetailData.parseModel(json["data"])
        return model
    }
}

class ComicDetailData: NSObject {
    var message: String?
    var returnData: ComicDetailReturnData?
    var stateCode: NSNumber?
    
    class func parseModel(json: JSON) -> ComicDetailData {
        let model = ComicDetailData()
        model.message = json["message"].string
        model.returnData = ComicDetailReturnData.parseModel(json["returnData"])
        model.stateCode = json["stateCode"].number
        return model
    }
}

class ComicDetailReturnData: NSObject {
    var chapter_list: Array<ComicChapterList>?
    var comic: ComicData?
    var otherWorks: Array<ComicOtherWork>?
    
    class func parseModel(json: JSON) -> ComicDetailReturnData {
        let model = ComicDetailReturnData()
        var tmpArray = Array<ComicChapterList>()
        for (_,subjson) in json["chapter_list"] {
            tmpArray.append(ComicChapterList.parseModel(subjson))
        }
        model.chapter_list = tmpArray
        model.comic = ComicData.parseModel(json["comic"])
        var tmpArray1 = Array<ComicOtherWork>()
        for (_,subjson) in json["otherWorks"] {
            tmpArray1.append(ComicOtherWork.parseModel(subjson))
        }
        model.otherWorks = tmpArray1
        return model
    }
}

class ComicChapterList: NSObject {
    var chapter_id: String?
    var has_locked_image: String?
    var image_total: String?
    var is_new: NSNumber?
    var name: String?
    var pass_time: NSNumber?
    var price: String?
    var release_time: String?
    var size: String?
    var type: NSNumber?
    var zip_high_webp: String?
    
    class func parseModel(json: JSON) -> ComicChapterList {
        let model = ComicChapterList()
        model.chapter_id = json["chapter_id"].string
        model.has_locked_image = json["has_locked_image"].string
        model.image_total = json["image_total"].string
        model.is_new = json["is_new"].number
        model.name = json["name"].string
        model.pass_time = json["pass_time"].number
        model.price = json["price"].string
        model.release_time = json["release_time"].string
        model.size = json["size"].string
        model.type = json["type"].number
        model.zip_high_webp = json["zip_high_webp"].string
        return model
    }
}

class ComicData: NSObject {
    var accredit: NSNumber?
    var author: ComicAuthor?
    var cate_id: String?
    var comic_id: String?
    var cover: String?
    var description1: String?
    var is_vip: NSNumber?
    var last_update_time: NSNumber?
    var last_update_week: String?
    var name: String?
    var ori: String?
    var series_status: NSNumber?
    var short_description: String?
    var theme_ids: Array<String>?
    var thread_id: String?
    var type: String?
    var week_more: String?
    
    class func parseModel(json: JSON) -> ComicData {
        let model = ComicData()
        model.accredit = json["accredit"].number
        model.author = ComicAuthor.parseModel(json["author"])
        model.cate_id = json["cate_id"].string
        model.comic_id = json["comic_id"].string
        model.cover = json["cover"].string
        model.description1 = json["description"].string
        model.is_vip = json["is_vip"].number
        model.last_update_time = json["last_update_time"].number
        model.last_update_week = json["last_update_week"].string
        model.name = json["name"].string
        model.ori = json["ori"].string
        model.series_status = json["series_status"].number
        model.short_description = json["short_description"].string
        var tmpArray = Array<String>()
        for (_,subjson) in json["theme_ids"] {
            tmpArray.append(subjson.string!)
        }
        model.theme_ids = tmpArray
        model.thread_id = json["thread_id"].string
        model.type = json["type"].string
        model.week_more = json["week_more"].string
        return model
    }
}

class ComicAuthor: NSObject {
    var avatar: String?
    var id: String?
    var name: String?
    
    class func parseModel(json: JSON) -> ComicAuthor {
        let model = ComicAuthor()
        model.avatar = json["avatar"].string
        model.id = json["id"].string
        model.name = json["name"].string
        return model
    }
}

class ComicOtherWork: NSObject {
    var comicId: String?
    var coverUrl: String?
    var name: String?
    var passChapterNum: String?
    
    class func parseModel(json: JSON) -> ComicOtherWork {
        let model = ComicOtherWork()
        model.comicId = json["comicId"].string
        model.coverUrl = json["coverUrl"].string
        model.name = json["name"].string
        model.passChapterNum = json["passChapterNum"].string
        return model
    }
}
